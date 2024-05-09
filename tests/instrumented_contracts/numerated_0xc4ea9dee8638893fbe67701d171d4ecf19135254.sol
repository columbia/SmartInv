1 pragma solidity ^0.4.25;
2 
3 contract Conquest {
4     
5     /*=================================
6     =             EVENTS              =
7     =================================*/
8 	event onHiveCreated (
9         address indexed player,
10 		uint256 number,
11 		uint256 time
12     );
13 	
14 	event onDroneCreated (
15         address indexed player,
16 		uint256 number,
17 		uint256 time
18     );
19 	
20 	event onEnemyDestroyed (
21 		address indexed player,
22 		uint256 time
23 	);
24     
25     
26     /*=================================
27     =            MODIFIERS            =
28     =================================*/
29 	modifier onlyAdministrator() {
30         address _customerAddress = msg.sender;
31         require(administrator_ == _customerAddress);
32         _;
33     }
34     
35     
36     /*=================================
37     =         CONFIGURABLES           =
38     ==================================*/
39     uint256 internal ACTIVATION_TIME = 1544988600;  // when hives can be created
40 	bool internal contractActivated_ = true;
41 	bool internal payedOut_ = false;
42     
43     uint256 internal hiveCost_ = 0.075 ether;
44     uint256 internal droneCost_ = 0.01 ether;
45 	
46 	uint256 internal hiveXCommanderFee_ = 50;	// 50% from Hives to Commander
47 	uint256 internal droneXCommanderFee_ = 15;	// 15% from Drones to Commander
48     uint256 internal droneXHiveFee_ = 415;		// 41.5% from Drones to Commander (base 1000)
49 	
50     uint8 internal amountHives_ = 8;
51     uint8 internal dronesPerDay_ = 20;			// default 20
52 	bool internal conquesting_ = true;
53 	bool internal conquested_ = false;
54     
55     
56     /*=================================
57     =             DATASET             =
58     =================================*/
59     address internal administrator_;
60     address internal fundTHCAddress_;
61 	address internal fundP3DAddress_;
62     uint256 internal pot_;
63     mapping (address => Pilot) internal pilots_;
64     
65     address internal commander_;
66     address[] internal hives_;
67     address[] internal drones_;
68     
69     //uint256 internal DEATH_TIME;
70     uint256 internal dronePopulation_;
71     
72     
73     /*=================================
74     =         PUBLIC FUNCTIONS        =
75     =================================*/
76     constructor() 
77         public 
78     {
79         commander_ = address(this);
80         administrator_ = 0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1;
81         fundTHCAddress_ = 0x9674D14AF3EE5dDcD59D3bdcA7435E11bA0ced18;
82 		fundP3DAddress_ = 0xC0c001140319C5f114F8467295b1F22F86929Ad0;
83     }
84 	
85 	function startNewRound() 
86 		public 
87 	{
88 		// Conquesting needs to be finished
89 		require(!conquesting_);
90 		
91 		// payout everybody into their vaults
92 		if (!payedOut_) {
93 			_payout();
94 		}
95 		
96 		// reset all values
97 		_resetGame();
98 	}
99 	
100 	// VAULT
101 	function withdrawVault() 
102 		public 
103 	{
104 		address _player = msg.sender;
105 		uint256 _balance = pilots_[_player].vault;
106 		
107 		// Player must have ether in vault
108 		require(_balance > 0);
109 		
110 		// withdraw everything
111 		pilots_[_player].vault = 0;
112 		
113 		// payouts
114 		_player.transfer(_balance);
115 	}
116 	
117 	function createCarrierFromVault()
118 		public 
119 	{
120 		address _player = msg.sender;
121 		uint256 _vault = pilots_[_player].vault;
122 		
123 		// Player must have enough ether available in vault
124 		require(_vault >= hiveCost_);
125 		pilots_[_player].vault = _vault - hiveCost_;
126 		
127 		_createHiveInternal(_player);
128 	}
129 	
130 	function createDroneFromVault()
131 		public 
132 	{
133 		address _player = msg.sender;
134 		uint256 _vault = pilots_[_player].vault;
135 		
136 		// Player must have enough ether available in vault
137 		require(_vault >= droneCost_);
138 		pilots_[_player].vault = _vault - droneCost_;
139 		
140 		_createDroneInternal(_player);
141 	}    
142     
143 	// WALLET
144     function createCarrier() 
145 		public 
146 		payable
147 	{
148         address _player = msg.sender;
149         
150 		require(msg.value == hiveCost_);			// requires exact amount of ether
151         
152         _createHiveInternal(_player);
153     }	
154     
155     function createDrone()
156         public 
157 		payable
158     {
159 		address _player = msg.sender;
160 		
161 		require(msg.value == droneCost_);			// requires exact amount of ether
162         
163         _createDroneInternal(_player);
164     }
165     
166     /* View Functions and Helpers */
167     function openAt()
168         public
169         view
170         returns(uint256)
171     {
172         return ACTIVATION_TIME;
173     }
174     
175     function getHives()
176 	    public
177 	    view
178 	    returns(address[])
179 	{
180 	    return hives_;
181 	}
182 	
183 	function getDrones()
184 	    public
185 	    view
186 	    returns(address[])
187 	{
188 	    return drones_;
189 	}
190 	
191 	/*function populationIncrease()
192 		public
193 		view
194 		returns(uint256)
195 	{
196 		return drones_.length - dronePopulation_;
197 	}*/
198     
199     function commander()
200         public
201         view
202         returns(address)
203     {
204         return commander_;
205     }
206     
207     function conquesting() 
208         public
209         view
210         returns(bool)
211     {
212         return conquesting_;
213     }
214 	
215 	function getCommanderPot()
216         public
217         view
218         returns(uint256)
219     {
220 		// total values
221         uint256 _hivesIncome = hives_.length * hiveCost_;		// total hives pot addition
222         uint256 _dronesIncome = drones_.length * droneCost_;	// total drones pot addition
223         uint256 _pot = pot_ + _hivesIncome + _dronesIncome; 	// old pot may feeds this round
224 		uint256 _fee = _pot / 10;       						// 10%
225         _pot = _pot - _fee;										// 90% residual
226 		
227 		_hivesIncome = (_hivesIncome * 9) / 10;
228         _dronesIncome = (_dronesIncome * 9) / 10;
229 		
230         // relative values
231         uint256 _toCommander = (_hivesIncome * hiveXCommanderFee_) / 100 +		// 50% from Hives to Commander
232                                (_dronesIncome * droneXCommanderFee_) / 100;  	// 15% from Drones to Commander
233 		
234 		return _toCommander;
235 	}
236 	
237 	function getHivePot()
238         public
239         view
240         returns(uint256)
241     {
242 		// total values
243         uint256 _hivesIncome = hives_.length * hiveCost_;		// total hives pot addition
244         uint256 _dronesIncome = drones_.length * droneCost_;	// total drones pot addition
245         uint256 _pot = pot_ + _hivesIncome + _dronesIncome; 	// old pot may feeds this round
246 		uint256 _fee = _pot / 10;       						// 10%
247         _pot = _pot - _fee;										// 90% residual
248         
249 		_hivesIncome = (_hivesIncome * 9) / 10;
250         _dronesIncome = (_dronesIncome * 9) / 10;
251 		
252         // relative values
253         uint256 _toHives = (_dronesIncome * droneXHiveFee_) / 1000;    			// 41,5% from Drones to Hives
254 		
255 		return _toHives;
256     }
257 	
258 	function getDronePot()
259         public
260         view
261         returns(uint256)
262     {
263 		// total values
264         uint256 _hivesIncome = hives_.length * hiveCost_;		// total hives pot addition
265         uint256 _dronesIncome = drones_.length * droneCost_;	// total drones pot addition
266         uint256 _pot = pot_ + _hivesIncome + _dronesIncome; 	// old pot may feeds this round
267 		uint256 _fee = _pot / 10;       						// 10%
268         _pot = _pot - _fee;										// 90% residual
269         
270 		_hivesIncome = (_hivesIncome * 9) / 10;
271         _dronesIncome = (_dronesIncome * 9) / 10;
272 		
273         // relative values
274         uint256 _toCommander = (_hivesIncome * hiveXCommanderFee_) / 100 +		// 50% from Hives to Commander
275                                (_dronesIncome * droneXCommanderFee_) / 100;  	// 15% from Drones to Commander
276         uint256 _toHives = (_dronesIncome * droneXHiveFee_) / 1000;    			// 41,5% from Drones to Hives
277 		uint256 _toDrones = _pot - _toHives - _toCommander; 					// residual goes to squad
278 		
279 		return _toDrones;
280     }
281 	
282 	function vaultOf(address _player)
283 		public
284 		view
285 		returns(uint256)
286 	{
287 		return pilots_[_player].vault;
288 	}
289 	
290 	function lastFlight(address _player)
291 		public
292 		view
293 		returns(uint256)
294 	{
295 		return pilots_[_player].lastFlight;
296 	}
297 	
298 	/* Setter */
299     function setGameStatus(bool _active) 
300         onlyAdministrator()
301         public
302     {
303         contractActivated_ = _active;
304     }
305     
306     
307     /*=================================
308     =        PRIVATE FUNCTIONS        =
309     =================================*/
310 	function _createDroneInternal(address _player)
311 		internal 
312 	{
313 	    require(hives_.length == amountHives_);    					// all hives must be created
314 		require(conquesting_);										// Conquesting must be in progress
315 		require(now > pilots_[_player].lastFlight + 60 seconds);	// 1 drone per minute per address
316 	    
317 	    // check if certain amount of Drones have been built
318 	    // otherwise round ends
319 	    /*if (now > DEATH_TIME) {
320 	        if (populationIncrease() >= dronesPerDay_) {
321 	            dronePopulation_ = drones_.length;		// remember last drone population
322 	            DEATH_TIME = DEATH_TIME + 24 hours;		// set new death time limit
323 				
324 				// after increasing death time, "now" can still have exceeded it
325 				if (now > DEATH_TIME) {
326 					conquesting_ = false;
327 					return;
328 				}
329 	        } else {
330 	            conquesting_ = false;
331 	            return;
332 	        }
333 	    }*/
334 	    
335 		// release new drone
336         drones_.push(_player);
337 		pilots_[_player].lastFlight = now;
338 		
339 		emit onDroneCreated(_player, drones_.length, now);
340         
341 		// try to kill the Enemy
342 		_figthEnemy(_player);
343 	}
344 	
345 	function _createHiveInternal(address _player) 
346 		internal 
347 	{
348 	    require(now >= ACTIVATION_TIME);                                // round starts automatically at this time
349 	    require(hives_.length < amountHives_);                          // limited hive amount
350         require(!ownsHive(_player), "Player already owns a hive");      // does not own a hive yet
351         
352 		// open hive
353         hives_.push(_player);
354         
355         // activate death time of 24 hours
356         /*if (hives_.length == amountHives_) {
357             DEATH_TIME = now + 24 hours;
358         }*/
359 		
360 		emit onHiveCreated(_player, hives_.length, now);
361 	}
362     
363     function _figthEnemy(address _player)
364         internal
365     {
366         uint256 _drones = drones_.length;
367         
368         // is that Drone the killer?
369         uint256 _drone = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, _player, _drones))) % 289;
370         
371 		// Enemy has been killed
372 		if (_drone == 42) {
373 			conquesting_ = false;
374 			conquested_ = true;
375 			
376 			emit onEnemyDestroyed(_player, now);
377 		}
378     }
379     
380     /**
381      * Payout Commander, Hives and Drone Squad
382      */
383     function _payout()
384         internal
385     {
386         // total values
387         uint256 _hivesIncome = amountHives_ * hiveCost_;
388         uint256 _dronesIncome = drones_.length * droneCost_;
389         uint256 _pot = pot_ + _hivesIncome + _dronesIncome; 	// old pot may feeds this round
390 		uint256 _fee = _pot / 10;       						// 10%
391         _pot = _pot - _fee;										// 90% residual
392 		_hivesIncome = (_hivesIncome * 9) / 10;
393         _dronesIncome = (_dronesIncome * 9) / 10;
394 		
395         // relative values
396         uint256 _toCommander = (_hivesIncome * hiveXCommanderFee_) / 100 +		// 50% from Hives to Commander
397                                (_dronesIncome * droneXCommanderFee_) / 100;  	// 15% from Drones to Commander
398         uint256 _toHives = (_dronesIncome * droneXHiveFee_) / 1000;    			// 41,5% from Drones to Hives
399         uint256 _toHive = _toHives / 8;											// 1/8 to each hive
400         uint256 _toDrones = _pot - _toHives - _toCommander; 					// residual goes to squad
401         
402         // only payout Hives and Drones if they have conquested
403         if (conquested_) {
404             // payout hives
405             for (uint8 i = 0; i < 8; i++) {
406                 address _ownerHive = hives_[i];
407                 pilots_[_ownerHive].vault = pilots_[_ownerHive].vault + _toHive;
408                 _pot = _pot - _toHive;
409             }
410             
411             // payout drones
412             uint256 _squadSize;
413             if (drones_.length >= 4) { _squadSize = 4; }				// 4 drones available
414     		else                     { _squadSize = drones_.length; }	// less than 4 drones available
415             
416             // iterate 1-4 drones
417             for (uint256 j = (drones_.length - _squadSize); j < drones_.length; j++) {
418                 address _ownerDrone = drones_[j];
419                 pilots_[_ownerDrone].vault = pilots_[_ownerDrone].vault + (_toDrones / _squadSize);
420                 _pot = _pot - (_toDrones / _squadSize);
421             }
422         }
423         
424         // payout Commander if contract is not queen
425         if (commander_ != address(this)) {
426             pilots_[commander_].vault = pilots_[commander_].vault + _toCommander;
427             _pot = _pot - _toCommander;
428         }
429         
430         // payout Fee
431         fundTHCAddress_.transfer(_fee / 2);		// 50% -> THC
432 		fundP3DAddress_.transfer(_fee / 2);		// 50% -> P3D
433 		
434 		// excess goes to next rounds pot
435 		pot_ = _pot;
436 		
437 		payedOut_ = true;
438     }
439 	
440 	/**
441 	 * Prepare next round by resetting all values to default
442 	 */
443 	function _resetGame() 
444 		internal 
445 	{
446 		// start new round if contract is active
447 		if (contractActivated_) {
448 			address _winner = drones_[drones_.length - 1];
449 			
450 			commander_ = _winner;
451 			hives_.length = 0;
452 			drones_.length = 0;
453 			dronePopulation_ = 0;
454 			
455 			conquesting_ = true;
456 			conquested_ = false;
457 			
458 			payedOut_ = false;
459 			
460 			ACTIVATION_TIME = now + 5 minutes;
461 		}
462 	}
463     
464     /* Helper */
465     function ownsHive(address _player) 
466         internal
467         view
468         returns(bool)
469     {
470         for (uint8 i = 0; i < hives_.length; i++) {
471             if (hives_[i] == _player) {
472                 return true;
473             }
474         }
475         
476         return false;
477     }
478     
479     
480     /*=================================
481     =            DATA TYPES           =
482     =================================*/
483 	struct Pilot {
484 		uint256 vault;
485 		uint256 lastFlight;
486     }
487 }