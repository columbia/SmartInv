1 pragma solidity 0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 }
50 
51 contract Claimable is Ownable {
52   address public pendingOwner;
53 
54   modifier onlyPendingOwner() {
55     require(msg.sender == pendingOwner);
56     _;
57   }
58   
59   function transferOwnership(address newOwner) onlyOwner public {
60     pendingOwner = newOwner;
61   }
62 
63   function claimOwnership() onlyPendingOwner public {
64     OwnershipTransferred(owner, pendingOwner);
65     owner = pendingOwner;
66     pendingOwner = address(0);
67   }
68 }
69 
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   function pause() onlyOwner whenNotPaused public {
87     paused = true;
88     Pause();
89   }
90 
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     Unpause();
94   }
95 }
96 
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110  
111 library SafeERC20 {
112   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
113     assert(token.transfer(to, value));
114   }
115 
116   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
117     assert(token.transferFrom(from, to, value));
118   }
119 
120   function safeApprove(ERC20 token, address spender, uint256 value) internal {
121     assert(token.approve(spender, value));
122   }
123 }
124 
125 contract CanReclaimToken is Ownable {
126   using SafeERC20 for ERC20Basic;
127 
128   function reclaimToken(ERC20Basic token) external onlyOwner {
129     uint256 balance = token.balanceOf(this);
130     token.safeTransfer(owner, balance);
131   }
132 
133 }
134 
135 contract JackpotAccessControl is Claimable, Pausable, CanReclaimToken {
136     address public cfoAddress;
137     
138     function JackpotAccessControl() public {
139         cfoAddress = msg.sender;
140     }
141     
142     modifier onlyCFO() {
143         require(msg.sender == cfoAddress);
144         _;
145     }
146 
147     function setCFO(address _newCFO) external onlyOwner {
148         require(_newCFO != address(0));
149 
150         cfoAddress = _newCFO;
151     }
152 }
153 
154 contract JackpotBase is JackpotAccessControl {
155     using SafeMath for uint256;
156  
157     bool public gameStarted;
158     
159     address public gameStarter;
160     address public lastPlayer;
161 	address public player2;
162 	address public player3;
163 	address public player4;
164 	address public player5;
165 	
166     uint256 public lastWagerTimeoutTimestamp;
167 	uint256 public player2Timestamp;
168 	uint256 public player3Timestamp;
169 	uint256 public player4Timestamp;
170 	uint256 public player5Timestamp;
171 	
172     uint256 public timeout;
173     uint256 public nextTimeout;
174     uint256 public minimumTimeout;
175     uint256 public nextMinimumTimeout;
176     uint256 public numberOfWagersToMinimumTimeout;
177     uint256 public nextNumberOfWagersToMinimumTimeout;
178 	
179 	uint256 currentTimeout;
180 	
181     uint256 public wagerIndex = 0;
182     
183 	uint256 public currentBalance;
184 	
185     function calculateTimeout() public view returns(uint256) {
186         if (wagerIndex >= numberOfWagersToMinimumTimeout || numberOfWagersToMinimumTimeout == 0) {
187             return minimumTimeout;
188         } else {
189             uint256 difference = timeout - minimumTimeout;
190             
191             uint256 decrease = difference.mul(wagerIndex).div(numberOfWagersToMinimumTimeout);
192                    
193             return (timeout - decrease);
194         }
195     }
196 }
197 
198 contract PullPayment {
199   using SafeMath for uint256;
200 
201   mapping(address => uint256) public payments;
202   uint256 public totalPayments;
203 
204   function withdrawPayments() public {
205     address payee = msg.sender;
206     uint256 payment = payments[payee];
207 
208     require(payment != 0);
209     require(this.balance >= payment);
210 	
211     totalPayments = totalPayments.sub(payment);
212     payments[payee] = 0;
213 
214     assert(payee.send(payment));
215   }
216 
217   function asyncSend(address dest, uint256 amount) internal {
218     payments[dest] = payments[dest].add(amount);
219     totalPayments = totalPayments.add(amount);
220   }
221 }
222 
223 contract JackpotFinance is JackpotBase, PullPayment {
224     uint256 public feePercentage = 2500;
225     
226     uint256 public gameStarterDividendPercentage = 2500;
227     
228     uint256 public price;
229     
230     uint256 public nextPrice;
231     
232     uint256 public prizePool;
233     
234     // The current 5th wager pool (in wei).
235     uint256 public wagerPool5;
236 	
237 	// The current 13th wager pool (in wei).
238 	uint256 public wagerPool13;
239     
240     function setGameStarterDividendPercentage(uint256 _gameStarterDividendPercentage) external onlyCFO {
241         require(_gameStarterDividendPercentage <= 4000);
242         
243         gameStarterDividendPercentage = _gameStarterDividendPercentage;
244     }
245     
246     function _sendFunds(address beneficiary, uint256 amount) internal {
247         if (!beneficiary.send(amount)) {
248             asyncSend(beneficiary, amount);
249         }
250     }
251     
252     function withdrawFreeBalance() external onlyCFO {
253 		
254         uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool5).sub(wagerPool13);
255         
256         cfoAddress.transfer(freeBalance);
257 		currentBalance = this.balance;
258     }
259 }
260 
261 contract JackpotCore is JackpotFinance {
262     
263     function JackpotCore(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) public {
264         require(_timeout >= _minimumTimeout);
265         
266         nextPrice = _price;
267         nextTimeout = _timeout;
268         nextMinimumTimeout = _minimumTimeout;
269         nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;
270         //NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);
271     }
272     
273     //event NextGame(uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);
274     event Start(address indexed starter, uint256 timestamp, uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);
275     event End(address indexed winner, uint256 timestamp, uint256 prize);
276     event Bet(address player, uint256 timestamp, uint256 timeoutTimestamp, uint256 wagerIndex, uint256 newPrizePool);
277     event TopUpPrizePool(address indexed donater, uint256 ethAdded, string message, uint256 newPrizePool);
278     
279     function bet(bool startNewGameIfIdle) external payable {
280 		require(msg.value >= price);
281 		
282         _processGameEnd();
283 		
284         if (!gameStarted) {
285             require(!paused);
286 
287             require(startNewGameIfIdle);
288             
289             price = nextPrice;
290             timeout = nextTimeout;
291             minimumTimeout = nextMinimumTimeout;
292             numberOfWagersToMinimumTimeout = nextNumberOfWagersToMinimumTimeout;
293             
294             gameStarted = true;
295             
296             gameStarter = msg.sender;
297             
298             Start(msg.sender, now, price, timeout, minimumTimeout, numberOfWagersToMinimumTimeout);
299         }
300         
301         // Calculate the fees and dividends.
302         uint256 fee = price.mul(feePercentage).div(100000);
303         uint256 dividend = price.mul(gameStarterDividendPercentage).div(100000);
304 		
305         uint256 wagerPool5Part;
306 		uint256 wagerPool13Part;
307         
308 		// Calculate the wager pool part.
309         wagerPool5Part = price.mul(2).div(10);
310 		wagerPool13Part = price.mul(3).div(26);
311             
312         // Add funds to the wager pool.
313         wagerPool5 = wagerPool5.add(wagerPool5Part);
314 		wagerPool13 = wagerPool13.add(wagerPool13Part);
315 		
316 		prizePool = prizePool.add(price);
317 		prizePool = prizePool.sub(fee);
318 		prizePool = prizePool.sub(dividend);
319 		prizePool = prizePool.sub(wagerPool5Part);
320 		prizePool = prizePool.sub(wagerPool13Part);
321 		
322 		if (wagerIndex % 5 == 4) {
323             // On every 5th wager, give 2x back
324 			
325             uint256 wagerPrize5 = price.mul(2);
326             
327             // Calculate the missing wager pool part, remove earlier added wagerPool5Part
328             uint256 difference5 = wagerPrize5.sub(wagerPool5);
329 			prizePool = prizePool.sub(difference5);
330         
331             msg.sender.transfer(wagerPrize5);
332             
333             wagerPool5 = 0;
334         }
335 		
336 		if (wagerIndex % 13 == 12) {
337 			// On every 13th wager, give 3x back
338 			
339 			uint256 wagerPrize13 = price.mul(3);
340 			
341 			uint256 difference13 = wagerPrize13.sub(wagerPool13);
342 			prizePool = prizePool.sub(difference13);
343 			
344 			msg.sender.transfer(wagerPrize13);
345 			
346 			wagerPool13 = 0;
347 		}
348 
349 		player5 = player4;
350 		player4 = player3;
351 		player3 = player2;
352 		player2 = lastPlayer;
353 		
354 		player5Timestamp = player4Timestamp;
355 		player4Timestamp = player3Timestamp;
356 		player3Timestamp = player2Timestamp;
357 		
358 		if (lastWagerTimeoutTimestamp > currentTimeout) {
359 			player2Timestamp = lastWagerTimeoutTimestamp.sub(currentTimeout);
360 		}
361 		
362 		currentTimeout = calculateTimeout();
363 		
364         lastPlayer = msg.sender;
365         lastWagerTimeoutTimestamp = now + currentTimeout;
366         
367 		wagerIndex = wagerIndex.add(1);
368 		
369         Bet(msg.sender, now, lastWagerTimeoutTimestamp, wagerIndex, prizePool);
370         
371         _sendFunds(gameStarter, dividend);
372 		//_sendFunds(cfoAddress, fee);
373         
374         uint256 excess = msg.value - price;
375         
376         if (excess > 0) {
377             msg.sender.transfer(excess);
378         }
379 		
380 		currentBalance = this.balance;
381     }
382     
383     function topUp(string message) external payable {
384         require(gameStarted || !paused);
385         
386         require(msg.value > 0);
387         
388         prizePool = prizePool.add(msg.value);
389         
390         TopUpPrizePool(msg.sender, msg.value, message, prizePool);
391     }
392     
393     function setNextGame(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) external onlyCFO {
394         require(_timeout >= _minimumTimeout);
395     
396         nextPrice = _price;
397         nextTimeout = _timeout;
398         nextMinimumTimeout = _minimumTimeout;
399         nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;
400         //NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);
401     } 
402     
403     function endGame() external {
404         require(_processGameEnd());
405     }
406     
407     function _processGameEnd() internal returns(bool) {
408         if (!gameStarted) {
409             return false;
410         }
411     
412         if (now <= lastWagerTimeoutTimestamp) {
413             return false;
414         }
415         
416 		// gameStarted AND past the time limit
417         uint256 excessPool = wagerPool5.add(wagerPool13);
418         
419         _sendFunds(lastPlayer, prizePool);
420 		_sendFunds(cfoAddress, excessPool);
421         
422         End(lastPlayer, lastWagerTimeoutTimestamp, prizePool);
423         
424         gameStarted = false;
425         gameStarter = 0x0;
426         lastPlayer = 0x0;
427 		player2 = 0x0;
428 		player3 = 0x0;
429 		player4 = 0x0;
430 		player5 = 0x0;
431         lastWagerTimeoutTimestamp = 0;
432 		player2Timestamp = 0;
433 		player3Timestamp = 0;
434 		player4Timestamp = 0;
435 		player5Timestamp = 0;
436         wagerIndex = 0;
437         prizePool = 0;
438         wagerPool5 = 0;
439 		wagerPool13 = 0;
440 		currentBalance = this.balance;
441         
442         return true;
443     }
444 }