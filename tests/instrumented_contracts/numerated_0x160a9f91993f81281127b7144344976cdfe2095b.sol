1 pragma solidity ^0.4.23;
2 /**
3  * @title WinEtherPot10 ver 1.0 Prod
4  * @dev The WinEtherPot contract is an ETH lottery contract
5  * that allows unlimited entries at the cost of 0.1 ETH per entry.
6  * Winners are rewarded the pot.
7  */
8 contract WinEtherPot10 {
9  
10      
11     address public owner; 					// Contract Creator
12     uint private latestBlockNumber;         // Latest Block Number on BlockChain
13     bytes32 private cumulativeHash;			
14     address[] private bets;					// address list of people applied
15     mapping(address => uint256) winners;    // Winners
16 	
17 	uint256 ownerShare = 5;
18 	uint256 winnerShare = 95;
19 	bool splitAllowed = true;
20 	
21 	uint256 public minEntriesRequiredPerGame = 3;
22 	uint256 playerCount = 0;
23 	uint256 public potSize;
24 	
25 	bool autoDistributeWinning = true;   // when manual withdraw happens, distribute winnings also
26 	
27 	bool autoWithdrawWinner = true;   // autoWithdrawWinner and distribute winnings also
28 		
29 	bool public isRunning = true;
30 	
31 	uint256 public minEntryInWei = (1/10) * 1e18; // 0.1 Ether
32  	
33     
34 	// Bet placing events
35     event betPlaced(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
36     event betStarted(address thePersonWhoBet, uint moneyInWei );
37     event betAccepted(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
38 	event betNotPlaced(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
39       
40 	// winner draw events
41     event startWinnerDraw(uint256 randomInt, address winner, uint blockNumber , uint256 amountWonByThisWinner );	
42 	
43 	// amount won
44 	event amountWonByOwner(address ownerWithdrawer,  uint256 amount);
45 	event amountWonByWinner(address winnerWithdrawer,  uint256 amount);
46 	
47 	// withdraw events
48     event startWithDraw(address withdrawer,  uint256 amount);
49 	event successWithDraw(address withdrawer,  uint256 amount);
50 	event rollbackWithDraw(address withdrawer,  uint256 amount);
51 	
52     event showParticipants(address[] thePersons);
53     event showBetNumber(uint256 betNumber, address better);
54     
55     event calledConstructor(uint block, address owner);
56 	
57 	event successDrawWinner(bool successFlag ); 
58 	event notReadyDrawWinner(bool errorFlag ); 
59  
60     /**
61 	*    @dev Constructor only called once
62 	**/ 
63 	constructor() public {
64         owner = msg.sender;
65         latestBlockNumber = block.number;
66         cumulativeHash = bytes32(0);
67         
68         emit calledConstructor(latestBlockNumber, owner);
69     }
70  
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78  
79     /**
80      * @dev Send 0.1 ETHER Per Bet.
81      */
82     function placeBet() public payable returns (bool) {
83         
84 		if( isRunning == true ) {
85 		
86 			uint _wei = msg.value;
87 				   
88 			emit betStarted(msg.sender , msg.value);
89 			//require(_wei >= 0.1 ether);
90 			assert(_wei >= minEntryInWei);
91 			cumulativeHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber), cumulativeHash));
92 			
93 			emit betPlaced(msg.sender , msg.value , block.number);
94 			
95 			latestBlockNumber = block.number;
96 			bets.push(msg.sender);
97 			
98 			emit betAccepted(msg.sender , msg.value , block.number);
99 			
100 			potSize = potSize + msg.value;
101 		}else {
102 			
103 			emit betNotPlaced(msg.sender , msg.value , block.number);
104 		}
105 		
106 		if( autoWithdrawWinner == true ) {
107 			
108 			if( bets.length >= minEntriesRequiredPerGame ) {
109 				bool successDrawWinnerFlag = drawAutoWinner();
110 				emit successDrawWinner(successDrawWinnerFlag);
111 			}else {
112 			    emit notReadyDrawWinner(false);
113 			}
114 		}
115         return true;
116     }
117  
118     function drawAutoWinner() private returns (bool) {
119         
120 		bool boolSuccessFlag = false;
121 		
122 		assert( bets.length >= minEntriesRequiredPerGame );
123         
124 		latestBlockNumber = block.number;
125         
126 		bytes32 _finalHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber-1), cumulativeHash));
127         
128 		uint256 _randomInt = uint256(_finalHash) % bets.length;
129         
130 		address _winner = bets[_randomInt];
131 		
132 		uint256 amountWon = potSize ;
133         
134 		uint256 ownerAmt = amountWon * ownerShare /100 ;
135 		
136 		uint256 winnerAmt = amountWon * winnerShare / 100 ;
137 		
138 		
139 		
140 		
141 		if( splitAllowed == true ) {
142 		
143 		    emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , winnerAmt );
144 			winners[_winner] = winnerAmt;
145 			owner.transfer(ownerAmt);
146 			emit amountWonByOwner(owner, ownerAmt);
147 			
148 			if( autoDistributeWinning == true ) {
149 			   
150 				winners[_winner] = 0;
151 				
152 				if( _winner.send(winnerAmt)) {
153 				   emit successWithDraw(_winner, winnerAmt);
154 				   emit amountWonByWinner(_winner, winnerAmt);
155 				   
156 				}
157 				else {
158 				  winners[_winner] = winnerAmt;
159 				  emit rollbackWithDraw(_winner, winnerAmt);
160 				  
161 				}
162 			}
163 			
164 			
165 		} else {
166 		
167 		    emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , amountWon );
168 			winners[_winner] = amountWon;
169 			
170 			if( autoDistributeWinning == true ) {
171 			   
172 				winners[_winner] = 0;
173 				
174 				if( _winner.send(amountWon)) {
175 				   emit successWithDraw(_winner, amountWon);
176 				   emit amountWonByWinner(_winner, amountWon);
177 				}
178 				else {
179 				  winners[_winner] = amountWon;
180 				  emit rollbackWithDraw(_winner, amountWon);
181 				}
182 			}
183 		}
184 				
185         cumulativeHash = bytes32(0);
186         delete bets;
187 		
188 		potSize = 0;
189 		
190 		
191 		boolSuccessFlag = true;
192 		
193         return boolSuccessFlag;
194     }
195 	
196 	
197 	function drawWinner() public onlyOwner returns (address) {
198         
199 		assert( bets.length >= minEntriesRequiredPerGame );
200         
201 		latestBlockNumber = block.number;
202         
203 		bytes32 _finalHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber-1), cumulativeHash));
204         
205 		uint256 _randomInt = uint256(_finalHash) % bets.length;
206         
207 		address _winner = bets[_randomInt];
208 		
209 		uint256 amountWon = potSize ;
210         
211 		uint256 ownerAmt = amountWon * ownerShare /100 ;
212 		
213 		uint256 winnerAmt = amountWon * winnerShare / 100 ;
214 		
215 		if( splitAllowed == true ) {
216 			winners[_winner] = winnerAmt;
217 			owner.transfer(ownerAmt);
218 			emit amountWonByOwner(owner, ownerAmt);
219 			
220 			if( autoDistributeWinning == true ) {
221 			   
222 				winners[_winner] = 0;
223 				
224 				if( _winner.send(winnerAmt)) {
225 				   emit successWithDraw(_winner, winnerAmt);
226 				   emit amountWonByWinner(_winner, winnerAmt);
227 				   
228 				}
229 				else {
230 				  winners[_winner] = winnerAmt;
231 				  emit rollbackWithDraw(_winner, winnerAmt);
232 				  
233 				}
234 			}
235 			
236 			
237 		} else {
238 			winners[_winner] = amountWon;
239 			
240 			if( autoDistributeWinning == true ) {
241 			   
242 				winners[_winner] = 0;
243 				
244 				if( _winner.send(amountWon)) {
245 				   emit successWithDraw(_winner, amountWon);
246 				   emit amountWonByWinner(_winner, amountWon);
247 				}
248 				else {
249 				  winners[_winner] = amountWon;
250 				  emit rollbackWithDraw(_winner, amountWon);
251 				}
252 			}
253 		}
254 				
255         cumulativeHash = bytes32(0);
256         delete bets;
257 		
258 		potSize = 0;
259 		
260 		emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , winners[_winner] );
261 		
262         return _winner;
263     }
264 	
265  
266 	
267 	/**
268      * @dev Withdraw your winnings yourself
269      */
270     function withdraw() public returns (bool) {
271         uint256 amount = winners[msg.sender];
272 		
273 		emit startWithDraw(msg.sender, amount);
274 			
275         winners[msg.sender] = 0;
276 		
277         if (msg.sender.send(amount)) {
278 		
279 		    emit successWithDraw(msg.sender, amount);
280             return true;
281         } else {
282             winners[msg.sender] = amount;
283 			
284 			emit rollbackWithDraw(msg.sender, amount);
285 			
286             return false;
287         }
288     }
289  
290 	/**
291      * @dev List of Participants
292      */
293     function getParticipants() public onlyOwner returns (address[]) {
294        emit showParticipants(bets);
295        return bets;
296     }
297 	
298 	/**
299      * @dev Start / Stop the game
300      */
301 	function startTheGame() public onlyOwner returns (bool) {
302         
303        if( isRunning == false ) {
304 			isRunning = true;
305 	   }else {
306 			isRunning = false;
307 	   }
308 	   
309        return isRunning;
310     }
311  
312     /**
313      * @dev Set min number of enteried - dupe entried allowed
314      */
315     function setMinEntriesRequiredPerGame(uint256 entries) public onlyOwner returns (bool) {
316         
317         minEntriesRequiredPerGame = entries;
318         return true;
319     }
320 	
321 	
322 	/**
323      * @dev Set Min bet in wei
324      */
325     function setMinBetAmountInWei(uint256 amount) public onlyOwner returns (bool) {
326         
327         minEntryInWei = amount ;
328         return true;
329     }
330 	
331 	
332 	
333      /**
334      * @dev Get address for Bet
335      */
336     function getBet(uint256 betNumber) public returns (address) {
337         
338         emit showBetNumber(betNumber,bets[betNumber]);
339         return bets[betNumber];
340     }
341  
342 
343     /**
344      * @dev Get no of Entries in Contract
345      */
346     function getNumberOfBets() public view returns (uint256) {
347         return bets.length;
348     }
349 	
350 
351 	/**
352      * @dev Get min Entries required to start the draw
353      */
354     function minEntriesRequiredPerGame() public view returns (uint256) {
355         return minEntriesRequiredPerGame;
356     }
357 	
358 	/**
359      * @dev owner share
360      */
361     function contractOwnerSharePercentage() public view returns (uint256) {
362         return ownerShare;
363     }
364 	
365 	
366 	
367 	
368 	/**
369      * @dev winner share
370      */
371     function winnerSharePercentage() public view returns (uint256) {
372         return winnerShare;
373     }
374 	
375 	
376 	/**
377      * @dev pot size in wei
378      */
379     function potSizeInWei() public view returns (uint256) {
380         return potSize;
381     }
382 	
383 	
384 	/**
385      * @dev Destroy Contract
386      */
387 	function destroy() onlyOwner public { 
388 		uint256 potAmount =  potSize;
389 		owner.transfer(potAmount);
390 		selfdestruct(owner);  
391 	}
392 }