1 pragma solidity ^0.4.23;
2 /**
3  * @title WinEtherPot11 ver 1.0 Prod
4  * @dev The WinEtherPot contract is an ETH lottery contract
5  * that allows unlimited entries at the cost of 0.1 ETH per entry.
6  * Winners are rewarded the pot.
7  */
8 contract WinEtherPot11 {
9  
10      
11     address public owner; 					// Contract Creator
12     uint private latestBlockNumber;         // Latest Block Number on BlockChain
13     bytes32 private cumulativeHash;			
14     address[] private bets;					// address list of people applied for current game
15     mapping(address => uint256) winners;    // Winners
16 	
17 	uint256 ownerShare = 5;
18 	uint256 winnerShare = 95;
19 	bool splitAllowed = true;
20 	
21 	uint256 public gameRunCounter = 0;
22 	
23 	uint256 incremental = 1;
24 	
25 	
26 	uint256 public minEntriesRequiredPerGame = 3;
27 	uint256 playerCount = 0;
28 	uint256 public potSize;
29 	
30 	bool autoDistributeWinning = true;   // when manual withdraw happens, distribute winnings also
31 	
32 	bool autoWithdrawWinner = true;   // autoWithdrawWinner and distribute winnings also
33 		
34 	bool isRunning = true;
35 	
36 	uint256 public minEntryInWei = (1/10) * 1e18; // 0.1 Ether
37  	
38     
39 	// Bet placing events
40     event betPlaced(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
41     event betStarted(address thePersonWhoBet, uint moneyInWei );
42     event betAccepted(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
43 	event betNotPlaced(address thePersonWhoBet, uint moneyInWei, uint blockNumber );
44       
45 	// winner draw events
46     event startWinnerDraw(uint256 randomInt, address winner, uint blockNumber , uint256 amountWonByThisWinner );	
47 	
48 	// amount won
49 	event amountWonByOwner(address ownerWithdrawer,  uint256 amount);
50 	event amountWonByWinner(address winnerWithdrawer,  uint256 amount);
51 	
52 	// withdraw events
53     event startWithDraw(address withdrawer,  uint256 amount);
54 	event successWithDraw(address withdrawer,  uint256 amount);
55 	event rollbackWithDraw(address withdrawer,  uint256 amount);
56 	
57     event showParticipants(address[] thePersons);
58     event showBetNumber(uint256 betNumber, address better);
59     
60     event calledConstructor(uint block, address owner);
61 	
62 	event successDrawWinner(bool successFlag ); 
63 	event notReadyDrawWinner(bool errorFlag ); 
64  
65     /**
66 	*    @dev Constructor only called once
67 	**/ 
68 	constructor() public {
69         owner = msg.sender;
70         latestBlockNumber = block.number;
71         cumulativeHash = bytes32(0);
72         
73         emit calledConstructor(latestBlockNumber, owner);
74     }
75  
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83  
84     /**
85      * @dev Send 0.1 ETHER Per Bet.
86      */
87     function placeBet() public payable returns (bool) {
88         
89 		if( isRunning == true ) {
90 		
91 			uint _wei = msg.value;
92 				   
93 			emit betStarted(msg.sender , msg.value);
94 			//require(_wei >= 0.1 ether);
95 			assert(_wei >= minEntryInWei);
96 			cumulativeHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber), cumulativeHash));
97 			
98 			emit betPlaced(msg.sender , msg.value , block.number);
99 			
100 			latestBlockNumber = block.number;
101 			bets.push(msg.sender);
102 			
103 			emit betAccepted(msg.sender , msg.value , block.number);
104 			
105 			potSize = potSize + msg.value;
106 		}else {
107 			
108 			emit betNotPlaced(msg.sender , msg.value , block.number);
109 		}
110 		
111 		if( autoWithdrawWinner == true ) {
112 			
113 			if( bets.length >= minEntriesRequiredPerGame ) {
114 				bool successDrawWinnerFlag = drawAutoWinner();
115 				emit successDrawWinner(successDrawWinnerFlag);
116 				gameRunCounter = gameRunCounter + incremental;
117 			}else {
118 			    emit notReadyDrawWinner(false);
119 			}
120 		}
121         return true;
122     }
123  
124     function drawAutoWinner() private returns (bool) {
125         
126 		bool boolSuccessFlag = false;
127 		
128 		assert( bets.length >= minEntriesRequiredPerGame );
129         
130 		latestBlockNumber = block.number;
131         
132 		bytes32 _finalHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber-1), cumulativeHash));
133         
134 		uint256 _randomInt = uint256(_finalHash) % bets.length;
135         
136 		address _winner = bets[_randomInt];
137 		
138 		uint256 amountWon = potSize ;
139         
140 		uint256 ownerAmt = amountWon * ownerShare /100 ;
141 		
142 		uint256 winnerAmt = amountWon * winnerShare / 100 ;
143 		
144 		
145 		
146 		
147 		if( splitAllowed == true ) {
148 		
149 		    emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , winnerAmt );
150 			winners[_winner] = winnerAmt;
151 			owner.transfer(ownerAmt);
152 			emit amountWonByOwner(owner, ownerAmt);
153 			
154 			if( autoDistributeWinning == true ) {
155 			   
156 				winners[_winner] = 0;
157 				
158 				if( _winner.send(winnerAmt)) {
159 				   emit successWithDraw(_winner, winnerAmt);
160 				   emit amountWonByWinner(_winner, winnerAmt);
161 				   
162 				}
163 				else {
164 				  winners[_winner] = winnerAmt;
165 				  emit rollbackWithDraw(_winner, winnerAmt);
166 				  
167 				}
168 			}
169 			
170 			
171 		} else {
172 		
173 		    emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , amountWon );
174 			winners[_winner] = amountWon;
175 			
176 			if( autoDistributeWinning == true ) {
177 			   
178 				winners[_winner] = 0;
179 				
180 				if( _winner.send(amountWon)) {
181 				   emit successWithDraw(_winner, amountWon);
182 				   emit amountWonByWinner(_winner, amountWon);
183 				}
184 				else {
185 				  winners[_winner] = amountWon;
186 				  emit rollbackWithDraw(_winner, amountWon);
187 				}
188 			}
189 		}
190 				
191         cumulativeHash = bytes32(0);
192         delete bets;
193 		
194 		potSize = 0;
195 		
196 		
197 		boolSuccessFlag = true;
198 		
199         return boolSuccessFlag;
200     }
201 	
202 	
203 	function drawWinner() private onlyOwner returns (address) {
204         
205 		assert( bets.length >= minEntriesRequiredPerGame );
206         
207 		latestBlockNumber = block.number;
208         
209 		bytes32 _finalHash = keccak256(abi.encodePacked(blockhash(latestBlockNumber-1), cumulativeHash));
210         
211 		uint256 _randomInt = uint256(_finalHash) % bets.length;
212         
213 		address _winner = bets[_randomInt];
214 		
215 		uint256 amountWon = potSize ;
216         
217 		uint256 ownerAmt = amountWon * ownerShare /100 ;
218 		
219 		uint256 winnerAmt = amountWon * winnerShare / 100 ;
220 		
221 		if( splitAllowed == true ) {
222 			winners[_winner] = winnerAmt;
223 			owner.transfer(ownerAmt);
224 			emit amountWonByOwner(owner, ownerAmt);
225 			
226 			if( autoDistributeWinning == true ) {
227 			   
228 				winners[_winner] = 0;
229 				
230 				if( _winner.send(winnerAmt)) {
231 				   emit successWithDraw(_winner, winnerAmt);
232 				   emit amountWonByWinner(_winner, winnerAmt);
233 				   
234 				}
235 				else {
236 				  winners[_winner] = winnerAmt;
237 				  emit rollbackWithDraw(_winner, winnerAmt);
238 				  
239 				}
240 			}
241 			
242 			
243 		} else {
244 			winners[_winner] = amountWon;
245 			
246 			if( autoDistributeWinning == true ) {
247 			   
248 				winners[_winner] = 0;
249 				
250 				if( _winner.send(amountWon)) {
251 				   emit successWithDraw(_winner, amountWon);
252 				   emit amountWonByWinner(_winner, amountWon);
253 				}
254 				else {
255 				  winners[_winner] = amountWon;
256 				  emit rollbackWithDraw(_winner, amountWon);
257 				}
258 			}
259 		}
260 				
261         cumulativeHash = bytes32(0);
262         delete bets;
263 		
264 		potSize = 0;
265 		
266 		emit startWinnerDraw(_randomInt, _winner, latestBlockNumber , winners[_winner] );
267 		
268         return _winner;
269     }
270 	
271  
272 	
273 	/**
274      * @dev Withdraw your winnings yourself
275      */
276     function withdraw() private returns (bool) {
277         uint256 amount = winners[msg.sender];
278 		
279 		emit startWithDraw(msg.sender, amount);
280 			
281         winners[msg.sender] = 0;
282 		
283         if (msg.sender.send(amount)) {
284 		
285 		    emit successWithDraw(msg.sender, amount);
286             return true;
287         } else {
288             winners[msg.sender] = amount;
289 			
290 			emit rollbackWithDraw(msg.sender, amount);
291 			
292             return false;
293         }
294     }
295  
296 	/**
297      * @dev List of Participants
298      */
299     function _onlyAdmin_GetGameInformation() public onlyOwner returns (address[]) {
300        emit showParticipants(bets);
301 	   return bets;
302     }
303 	
304 	/**
305      * @dev Start / Stop the game
306      */
307 	function _onlyAdmin_ToggleGame() public onlyOwner returns (bool) {
308         
309        if( isRunning == false ) {
310 			isRunning = true;
311 	   }else {
312 			isRunning = false;
313 	   }
314 	   
315        return isRunning;
316     }
317  
318     /**
319      * @dev Set min number of enteried - dupe entried allowed
320      */
321     function _onlyAdmin_SetMinEntriesRequiredPerGame(uint256 entries) public onlyOwner returns (bool) {
322         
323         minEntriesRequiredPerGame = entries;
324         return true;
325     }
326 	
327 	
328 	/**
329      * @dev Set Min bet in wei
330      */
331     function _onlyAdmin_setMinBetAmountInWei(uint256 amount) public onlyOwner returns (bool) {
332         
333         minEntryInWei = amount ;
334         return true;
335     }
336 	
337 	
338     /**
339      * @dev Get address for Bet
340      */
341     function getBet(uint256 betNumber) private returns (address) {
342         
343         emit showBetNumber(betNumber,bets[betNumber]);
344         return bets[betNumber];
345     }
346  
347 
348     /**
349      * @dev Get no of Entries in Contract
350      */
351     function getNumberOfBets() public view returns (uint256) {
352         return bets.length;
353     }
354 	
355 
356 	/**
357      * @dev Get min Entries required to start the draw
358      */
359     function minEntriesRequiredPerGame() public view returns (uint256) {
360         return minEntriesRequiredPerGame;
361     }
362 	
363 
364 	/**
365      * @dev Destroy Contract
366      */
367 	function _onlyAdmin_Destroy() onlyOwner public { 
368 		uint256 potAmount =  potSize;
369 		owner.transfer(potAmount);
370 		selfdestruct(owner);  
371 	}
372 }