1 contract MyTokenShr {
2 	
3     Company public myCompany;
4 	bool active = false;
5 	
6 	modifier onlyActive {if(active) _ }
7     modifier onlyfromcompany {if(msg.sender == address(myCompany)) _ }
8 	
9 	function initContract(string _name, string _symbol, uint _firstTender, 
10 						  uint _startPrice )  {
11 		if(active) throw;
12 		name = _name;
13 		symbol =  _symbol;
14 		myCompany = Company(msg.sender);
15 		addTender(1,_firstTender, 0, _startPrice);
16 		active = true;
17 	}
18 
19 
20     // Tender Mechanism..
21 	// Issue New Tokens only in tender
22 	//
23   	struct Tender { uint id;
24                   uint maxstake;
25                   uint usedstake;
26                   address reservedFor;
27                   uint priceOfStake;
28   	}
29  	Tender[] activeTenders;
30   
31   	function addTender(uint nid, uint nmaxstake, address nreservedFor,uint _priceOfStake) {
32 
33 		//ToDo: freigabe durch Board
34     
35      	Tender memory newt;
36       	newt.id = nid;
37       	newt.maxstake = nmaxstake;
38       	newt.usedstake = 0;
39       	newt.reservedFor = nreservedFor;
40       	newt.priceOfStake = _priceOfStake;
41       
42       	activeTenders.push(newt);
43   	}
44 
45     function issuetender(address _to, uint tender, uint256 _value) onlyfromcompany {
46 
47         for(uint i=0;i<activeTenders.length;i++){
48             if(activeTenders[i].id == tender){
49                 if(activeTenders[i].reservedFor == 0 ||
50                     activeTenders[i].reservedFor == _to ){
51                         uint stake = _value / activeTenders[i].priceOfStake;
52                         if(activeTenders[i].maxstake-activeTenders[i].usedstake >= stake){
53                             if (balanceOf[_to] + stake < balanceOf[_to]) throw; // Check for overflows
54                             balanceOf[_to] += stake;                            // Add the same to the recipient
55 							totalSupply += stake;
56 							updateBalance(_to,balanceOf[_to]);
57                             Transfer(this, _to, stake); 
58                             activeTenders[i].usedstake += stake; // Notify anyone listening that this transfer took place
59                             
60                         }
61                         
62                     }
63             }
64         }
65     }
66 	function destroyToken(address _from, uint _amo) {
67 		if(balanceOf[_from] < _amo) throw;
68 		balanceOf[_from] -= _amo;
69 		updateBalance(_from,balanceOf[_from]);
70 		totalSupply -= _amo;
71  	}
72 	
73 	
74 	uint public pricePerStake = 1;
75 
76 
77 	function registerEarnings (uint _stake) {
78 
79 		//_stake zu verteilen..
80 		//totalSupply  anteile..
81 		//balanceOf  ... mein stake..
82 		for(uint i;i<userCnt;i++){
83 			uint earning = _stake * balanceByID[i].balamce / totalSupply;
84 			balanceByID[i].earning += earning;
85 		}
86 	}
87 	function queryEarnings(address _addr) returns (uint){
88 		return balanceByAd[_addr].earning;
89 	}
90 	function bookEarnings(address _addr, uint _amo){
91 		balanceByAd[_addr].earning -=  _amo;
92 	}
93 
94 	function setPricePerStake(uint _price)  {
95         //ToDo: vote mechanismus..  Boarddecission
96         pricePerStake = _price;
97     }
98 
99 	//
100 	// The Real Token Code..
101     /* Public variables of the token */
102     string public standard = 'Token 0.1';
103     string public name;
104     string public symbol;
105     uint8 public decimals = 8;
106     uint256 public totalSupply = 0;
107 
108     /* This creates an array with all balances */
109     mapping (address => uint256) public balanceOf;
110 
111 
112 
113 	struct balance {
114 		uint id;
115 		address ad;
116 		uint earning;
117 		uint balamce;
118 
119 	}	
120 	mapping (address  => balance) public balanceByAd;
121 	mapping (uint => balance) public balanceByID;
122 	uint userCnt=0;
123 	
124 	function updateBalance(address _addr, uint _bal){
125 		if(balanceByAd[_addr].id == 0){
126 			userCnt++;
127 			balanceByAd[_addr] = balance(userCnt, _addr, 0,_bal);
128 			balanceByID[userCnt] = balanceByAd[_addr];
129 		} else {
130 			balanceByAd[_addr].balamce = _bal;
131 		}
132 		
133 	}
134 	
135 	
136     /* This generates a public event on the blockchain that will notify clients */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     
139 
140     
141     /* Send coins */
142     function transfer(address _to, uint256 _value) {
143         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
144         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
145 
146         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
147         balanceOf[_to] += _value;                            // Add the same to the recipient
148 		updateBalance(_to,balanceOf[_to]);
149 		updateBalance(msg.sender,balanceOf[msg.sender]);
150 
151         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
152     }
153 
154     /* This unnamed function is called whenever someone tries to send ether to it */
155     function () {
156         throw;     // Prevents accidental sending of ether
157     }
158 	
159 
160 }
161 
162 
163 
164 
165 contract Project {
166 	function setCompany(){
167 		
168 	}
169 
170 
171 
172 	
173 }
174 
175 contract SlotMachine {
176 
177 	address CompanyAddress = 0;
178 	
179 	uint256 maxEinsatz = 1 ether;
180 	uint256 winFaktor = 2000;
181 	uint256 maxWin=maxEinsatz * winFaktor;
182 	uint public minReserve=maxWin ;
183 	uint public maxReserve=maxWin * 2;
184 	uint public sollReserve=maxWin+(maxWin * 2 / 10);
185 	
186 //1 ether * 2000 + (1 ether * 2000 *2/10)
187 //	uint256 percOfBuffer=100;
188 	
189 	int earnings = 0;
190 	uint public gamerun=0;
191 	uint[4] public wins;
192 
193 	//Constructor
194 	function SlotMachine(){
195 		
196 	}
197 	function setCompany(){
198 		if(CompanyAddress != 0) throw;
199 		CompanyAddress=msg.sender; //Nail to Company..
200 	}
201 	
202 	//Load/Unload Calls for Company..
203 	function closeBooks() {
204 		if(msg.sender != CompanyAddress) throw; //Only Internal Call..
205 		if(earnings <= 0) throw;
206 		if(this.balance < maxReserve) return;
207 		uint inc=this.balance-maxReserve;
208 		bool res = Company(CompanyAddress).send(inc);
209 	}
210 	function dumpOut() {
211 		if(msg.sender != CompanyAddress) throw; //Only Internal Call..	
212 		bool result = msg.sender.send(this.balance);
213 	}
214 	
215 	uint _nr ;
216 	uint _y;
217 	uint _win;
218 	function(){
219 		
220 		if(msg.sender == CompanyAddress) {
221 			//just a fill up..
222 			return;
223 		}
224 		
225 		//ok here goes the game..
226 		uint einsatz=msg.value;
227 		if(einsatz * winFaktor > this.balance) throw; //cant do this game..
228 		
229 		//Play the game..
230 		uint nr = now; //block.number;
231 		uint y = nr & 3;
232 		
233 		uint win = 0;
234 		if(y==0) wins[0]++;
235 		if(y==1) {wins[1]++; win = (msg.value * 2)  + (msg.value / 2);}
236 		if(y==2) wins[2]++;
237 		
238 		earnings += int(msg.value);
239 
240 		if(win > 0) { // half win..
241 			bool res = msg.sender.send(win);
242 			earnings -= int(win);		
243 		}
244 		gamerun++;
245 		_nr=nr;
246 		_win=win;
247 		_y=y;
248 		
249 		//Final.. Cleanup.. and so on..
250 		if(this.balance < minReserve){
251 			Company(CompanyAddress).requestFillUp(sollReserve-this.balance);
252 		}
253 
254 	}
255 	
256 }
257 
258 
259 /////////////
260 //
261 // contract Globals
262 //
263 // wird in Company eingebunden..
264 // speichert globale Variablen..
265 //
266 contract Globals {
267 	MyTokenShr public myBackerToken;
268     MyTokenShr public myShareToken;
269 		
270 	uint public startSlotAt = 1 ether * 2000 + (1 ether * 2000 *2/10);//100 ether; 
271 	
272 	uint BudgetSlot = 0;
273 	uint BudgetProject = 0;
274 	uint BudgetReserve = 0;
275 	
276 	uint IncomeShare =0;
277 	uint IncomeBacker =0;
278 
279 }
280 
281 /////////////
282 //
283 // contract Board
284 //
285 // wird in Company eingebunden..
286 // verwaltet das Board.. das Board besteht aus 3 Adressen,
287 // die mit einem Voting mechanismus von den ShareHolden (MyShareToken)
288 // gewÃÂÃÂÃÂÃÂ¤hlt und ausgetauscht werden
289 // 
290 // Board Member kÃÂÃÂÃÂÃÂ¶nnen verschiedene Tasks auslÃÂÃÂÃÂÃÂ¶sen
291 // und Parameter einstellen.
292 contract Board is Globals{
293 	
294 
295     address[3] public Board;
296 	    
297     function _isBoardMember(address c) returns(bool){
298         for(uint i=0;i<Board.length;i++){
299             if(Board[i] == c) return true;
300         }
301         return false;
302     }
303 	
304 	    modifier onlybyboardmember {if(_isBoardMember(tx.origin)) _ }
305 
306 		// Voting Process..
307 	// Vote for an BoardMember,
308 	//
309 	//	   	function startBoardProposal(uint _place, address _nmbr)
310 	//		function killBoardProposal(uint _place, address _nmbr) 
311 	//		function vote(uint _place, address _nmbr, bool pro)
312 	//
313 	struct Proposal {
314 		address newBoardMember;
315     	uint placeInBoard;
316         uint givenstakes;
317     	int ergebnis;
318 		bool active;
319         mapping (address => bool)  voted;
320 	}
321     
322     Proposal[] Proposals;
323 		uint Abalance;
324 		uint Asupply ;
325 		bool Abmb;
326 
327     function startBoardProposal(uint _place, address _nmbr) public{
328 
329 		Abalance = myShareToken.balanceOf(msg.sender);
330 		 Asupply = myShareToken.totalSupply();
331 		 Abmb = _isBoardMember(msg.sender);
332 		
333 		if(( Abalance > ( Asupply / 1000 )) || 
334                 _isBoardMember(msg.sender)){
335                    	Proposals.push(Proposal(_nmbr, _place, 0, 0, true));
336         }
337     }      
338 	
339 	function killBoardProposal(uint _place, address _nmbr) public{
340 		if(  _isBoardMember(msg.sender)){
341  			for(var i=0;i<Proposals.length;i++){
342 				if((Proposals[i].placeInBoard == _place) && 
343 			   		(Proposals[i].newBoardMember == _nmbr) ){
344 					delete Proposals[i];
345 				}
346 			}
347 	   	}
348 	}
349      
350     function voteBoardProposal(uint _place, address _nmbr, bool pro) public {
351 		for(var i=0;i<Proposals.length;i++){
352 			if((Proposals[i].placeInBoard == _place) && 
353 			   (Proposals[i].newBoardMember == _nmbr) && 
354 			   (Proposals[i].active == true) ){
355 				
356         		if(Proposals[i].voted[msg.sender]) throw; //already voted..
357         		
358 				Proposals[i].givenstakes += myShareToken.balanceOf(msg.sender);
359 
360 				if( pro) Proposals[i].ergebnis += int(myShareToken.balanceOf(msg.sender));
361 														
362 				else Proposals[i].ergebnis -= int(myShareToken.balanceOf(msg.sender));
363         		
364         		Proposals[i].voted[msg.sender] = true;
365        
366         		//finale checks..
367 				if( myShareToken.totalSupply() / 2 < Proposals[i].givenstakes) { //more then 50% voted.. finish..
368             		if(Proposals[i].ergebnis > 0)      { // ergebnis positiv.. tausche boardmember aus..
369 
370 						Board[_place] = _nmbr;
371 
372 						Proposals[i].active = false;
373             		}
374         		}
375 			}
376 		}
377     }
378 
379 
380 }
381 
382 /////////////
383 //
384 // contract SlotMachineMngr
385 //
386 // wird in Company eingebunden..
387 // verwaltet das SlotMachines.. 
388 /*	uint256 maxEinsatz = 1 ether;
389 	uint256 winFaktor = 2000;
390 	uint256 maxWin=maxEinsatz * winFaktor;
391 	uint public minReserve=maxWin ;
392 	uint public maxReserve=maxWin * 2;
393 	uint public sollReserve=1 ether * 2000 * 2 / 10;
394 */
395 contract SlotMachineMngr is Board{	//
396 	//adding SlotMachines...
397 	//  and managing SlotMachines...
398 	address private addSlotBy = 0;
399 	address private newSlotAddr;
400 	SlotMachine[] public Slots;
401 	
402 	function _slotAddNew(address _addr) public onlybyboardmember {
403 		if(addSlotBy != 0) throw;
404 		
405 		if(BudgetSlot < startSlotAt) return;
406 				
407 		addSlotBy = msg.sender;
408 		newSlotAddr = _addr;
409 	}
410 	function _slotCommitNew(address _addr) public onlybyboardmember {
411 		if(msg.sender==addSlotBy) throw; //no self commit
412 		if(newSlotAddr != _addr) throw;
413 		
414 		SlotMachine Slot = SlotMachine(newSlotAddr);
415 		Slot.setCompany();
416 		bool res = Slot.send(startSlotAt);
417 		Slots.push(Slot);	
418 		addSlotBy = 0;		
419 	}
420 	function _slotCancelNew() public onlybyboardmember {
421 		addSlotBy = 0;
422 	}
423 }
424 /////////////
425 //
426 // contract ProjectMngr
427 //
428 // wird in Company eingebunden..
429 // verwaltet das Projekte..
430 // Projekte sind einmalige Budget Contracts die zum erledigen 
431 // diverser Aufgaben angelegt werden. 
432 contract ProjectMngr is Board {
433 		//
434 	//adding Projects...
435 	// 
436 	address private addProjectBy = 0;
437 	address private newProjectAddr;
438 	uint private newProjectBudget;
439 	Project[] public Projects;
440 	
441 	function _projectAddNew(address _addr, uint _budget) public onlybyboardmember {
442 		if(addProjectBy != 0) throw;
443 		
444 		if(BudgetProject < _budget) return;
445 		
446 		newProjectBudget = _budget;
447 		addProjectBy = msg.sender;
448 		newProjectAddr = _addr;
449 	}
450 	function _projectCommitNew(address _addr) public onlybyboardmember {
451 		if(msg.sender==addProjectBy) throw; //no self commit
452 		if(newProjectAddr != _addr) throw;
453 		
454 		Project myProject = Project(newProjectAddr);
455 		myProject.setCompany();
456 		bool res = myProject.send(newProjectBudget);
457 		Projects.push(myProject);	
458 		addProjectBy = 0;		
459 	}
460 	function _projectCancelNew() public onlybyboardmember {
461 		addProjectBy = 0;
462 	}
463 
464 }
465 
466 /////////////
467 //
468 // contract Company
469 //
470 contract Company  is Globals, Board, SlotMachineMngr, ProjectMngr {//, managedbycompany {
471 
472 	    
473 	function fillUpSlot(uint _id, uint _amo){
474 		uint ts = _amo;
475 		if(ts<=BudgetSlot){BudgetSlot -= ts; ts=0;}
476 		else {ts -= BudgetSlot; BudgetSlot = 0;}
477 
478 		if(ts>0){
479 			if(ts<=BudgetReserve){BudgetReserve -= ts; ts=0;}
480 			else {ts -= BudgetReserve; BudgetReserve = 0;}
481 		}
482 		
483 		if(ts>0){
484 			if(ts<=BudgetProject){BudgetProject -= ts; ts=0;}
485 			else {ts -= BudgetProject; BudgetProject = 0;}
486 		}
487 	}
488 	function fillUpProject(uint _id, uint _amo){
489 		throw; //No Refill for Project..
490 	}
491 	function requestFillUp(uint _amo){
492 		//From SlotMachine?
493 		for(uint i=0;i<Slots.length;i++){
494 			if(Slots[i] == msg.sender){
495 				fillUpSlot(i, _amo);
496 				return;
497 			}
498 		}
499 		for(uint x=0;x<Projects.length;x++){
500 			if(Projects[x] == msg.sender){
501 				fillUpProject(x, _amo);
502 				return;
503 			}
504 		}
505 	}
506 
507 	// 
508 	// Taks fuer Initialisierung..
509 	//							
510 	function _addPools(address _backer, address _share){
511 
512 		myShareToken = MyTokenShr(_share);
513 		myShareToken.initContract("SMShares","XXSMS", 0.1 ether, 1);
514 
515         myBackerToken = MyTokenShr(_backer);
516 		myBackerToken.initContract("SMBShares","XXSMBS", 12000000 ether, 1);
517 		
518 	}
519 	
520 	// 
521 	// Taks fuer Abrechnung..
522 	//							
523 	function _dispatchEarnings() {
524 		if(IncomeShare > 0) {
525 			myShareToken.registerEarnings(IncomeShare);
526 			IncomeShare=0;
527 		}
528 		if(IncomeBacker > 0 ) {
529 			myBackerToken.registerEarnings(IncomeBacker);
530 			IncomeBacker=0;
531 		}
532 	}
533 	
534 	function _closeBooks() {
535 		for(var i=0;i<Slots.length;i++){
536 			Slots[i].closeBooks();
537 		}
538 	}
539 	function _dumpToCompany() {
540 		for(var i=0;i<Slots.length;i++){
541 			Slots[i].dumpOut();			
542 		}
543 	}
544 
545 	//
546 	// auszahlen
547 	//
548 	enum pool {backer_token,backer_earn, share_earn}
549 
550 	function payOut(pool _what, uint _amo){
551 		uint earn;
552 		if(_what == pool.backer_token){
553 			 earn = myBackerToken.balanceOf(msg.sender);
554 			if(earn<_amo)throw;
555 			if(msg.sender.send(_amo)) myBackerToken.destroyToken(msg.sender,_amo);
556 		}
557 		if(_what == pool.backer_earn){
558 			 earn = myBackerToken.queryEarnings(msg.sender);
559 			if(earn<_amo)throw;
560 			if(msg.sender.send(_amo)) myBackerToken.bookEarnings(msg.sender, _amo);
561 		}
562 		if(_what == pool.share_earn){
563 			 earn = myBackerToken.queryEarnings(msg.sender);
564 			if(earn<_amo)throw;
565 			if(msg.sender.send(_amo)) myBackerToken.bookEarnings(msg.sender, _amo);
566 		}
567 		
568 	}
569     
570 	//
571 	// Geldeingang verbuchen..
572 	//
573     function buyShare(uint tender,bool _share){
574 		if(!_share)
575 	        myShareToken.issuetender(msg.sender,tender, msg.value);
576 		else
577 	       myBackerToken.issuetender(msg.sender,tender, msg.value);
578 			
579 		BudgetSlot += (msg.value * 90 / 100);
580 		BudgetProject += (msg.value * 5 / 100);
581 		BudgetReserve += (msg.value * 5 / 100);
582     }
583     function bookEarnings(){
584 				IncomeShare += (msg.value * 33 / 100);
585 				IncomeBacker += (msg.value * 33 / 100);
586 				BudgetSlot += (msg.value * 90 / 100 / 3);
587 				BudgetProject += (msg.value * 2 / 100 / 3);
588 				BudgetReserve += (msg.value * 2 / 100);
589     }
590     
591 	// Geldeingang ohne weitere Parameter..
592 	function(){ 
593 		for(uint i=0;i<Slots.length;i++){
594 			if(Slots[i] == msg.sender){
595 				bookEarnings();
596 				return;
597 			}
598 		}		
599         buyShare(1, true);
600     }
601 
602 }
603 
604 //EOF