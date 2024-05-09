1 pragma solidity ^0.4.25;
2  
3 /**
4 *
5 *  https://fairdapp.com/crash/  https://fairdapp.com/crash/   https://fairdapp.com/crash/
6 *
7 *
8 *        _______     _       ______  _______ ______ ______  
9 *       (_______)   (_)     (______)(_______|_____ (_____ \ 
10 *        _____ _____ _  ____ _     _ _______ _____) )____) )
11 *       |  ___|____ | |/ ___) |   | |  ___  |  ____/  ____/ 
12 *       | |   / ___ | | |   | |__/ /| |   | | |    | |      
13 *       |_|   \_____|_|_|   |_____/ |_|   |_|_|    |_|
14 *       
15 *        ______       ______     _______                  _     
16 *       (_____ \     (_____ \   (_______)                | |    
17 *        _____) )   _ _____) )   _        ____ _____  ___| |__  
18 *       |  ____/ | | |  ____/   | |      / ___|____ |/___)  _ \ 
19 *       | |     \ V /| |        | |_____| |   / ___ |___ | | | |
20 *       |_|      \_/ |_|         \______)_|   \_____(___/|_| |_|
21 *                                                        
22 *   
23 *  Warning: 
24 *
25 *  This contract is intented for entertainment purpose only.
26 *  All could be lost by sending anything to this contract address. 
27 *  All users are prohibited to interact with this contract if this 
28 *  contract is in conflict with user’s local regulations or laws.   
29 *  
30 *  -Just another unique concept by the FairDAPP community.
31 *  -The FIRST PvP Crash game ever created!  
32 *
33 */
34 
35 contract FairExchange{
36     function balanceOf(address _customerAddress) public view returns(uint256);
37     function myTokens() public view returns(uint256);
38     function transfer(address _toAddress, uint256 _amountOfTokens) public returns(bool);
39 }
40 
41 contract PvPCrash {
42  
43     using SafeMath for uint256;
44     
45     /**
46      * @dev Modifiers
47      */
48  
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53     
54     modifier gasMin() {
55         require(gasleft() >= gasLimit);
56         require(tx.gasprice <= gasPriceLimit);
57         _;
58     }
59     
60     modifier isHuman() {
61         address _customerAddress = msg.sender;
62         if (_customerAddress != address(fairExchangeContract)){
63             require(_customerAddress == tx.origin);
64             _;
65         }
66     }
67     
68     event Invest(address investor, uint256 amount);
69     event Withdraw(address investor, uint256 amount);
70     
71     event FairTokenBuy(uint256 indexed ethereum, uint256 indexed tokens);
72     event FairTokenTransfer(address indexed userAddress, uint256 indexed tokens, uint256 indexed roundCount);
73     event FairTokenFallback(address indexed userAddress, uint256 indexed tokens, bytes indexed data);
74 
75  
76     mapping(address => mapping (uint256 => uint256)) public investments;
77     mapping(address => mapping (uint256 => uint256)) public joined;
78     mapping(address => uint256) public userInputAmount;
79     mapping(uint256 => uint256) public roundStartTime;
80     mapping(uint256 => uint256) public roundEndTime;
81     mapping(uint256 => uint256) public withdrawBlock;
82     
83     bool public gameOpen;
84     bool public roundEnded;
85     uint256 public roundCount = 1;
86     uint256 public startCoolDown = 5 minutes;
87     uint256 public endCoolDown = 5 minutes;
88     uint256 public minimum = 10 finney;
89     uint256 public maximum = 5 ether;
90     uint256 public maxNumBlock = 3;
91     uint256 public refundRatio = 50;
92     uint256 public gasPriceLimit = 25000000000;
93     uint256 public gasLimit = 300000;
94     
95     address constant public owner = 0xbC817A495f0114755Da5305c5AA84fc5ca7ebaBd;
96     
97     FairExchange constant private fairExchangeContract = FairExchange(0xdE2b11b71AD892Ac3e47ce99D107788d65fE764e);
98 
99     PvPCrashFormula constant private pvpCrashFormula = PvPCrashFormula(0xe3c518815fE5f1e970F8fC5F2eFFcF2871be5C4d);
100     
101 
102     /**
103      * @dev Сonstructor Sets the original roles of the contract
104      */
105  
106     constructor() 
107         public 
108     {
109         roundStartTime[roundCount] = now + startCoolDown;
110         gameOpen = true;
111     }
112     
113     function setGameOpen() 
114         onlyOwner
115         public  
116     {
117         if (gameOpen) {
118             require(roundEnded);
119             gameOpen = false;
120         } else
121             gameOpen = true;
122     }
123     
124     function setMinimum(uint256 _minimum) 
125         onlyOwner
126         public  
127     {
128         require(_minimum < maximum);
129         minimum = _minimum;
130     }
131     
132     function setMaximum(uint256 _maximum) 
133         onlyOwner
134         public  
135     {
136         require(_maximum > minimum);
137         maximum = _maximum;
138     }
139     
140     function setRefundRatio(uint256 _refundRatio) 
141         onlyOwner
142         public 
143     {
144         require(_refundRatio <= 100);
145         refundRatio = _refundRatio;
146     }
147     
148     function setGasLimit(uint256 _gasLimit) 
149         onlyOwner
150         public 
151     {
152         require(_gasLimit >= 200000);
153         gasLimit = _gasLimit;
154     }
155     
156     function setGasPrice(uint256 _gasPrice) 
157         onlyOwner
158         public 
159     {
160         require(_gasPrice >= 1000000000);
161         gasPriceLimit = _gasPrice;
162     }
163     
164     function setStartCoolDown(uint256 _coolDown) 
165         onlyOwner
166         public 
167     {
168         require(!gameOpen);
169         startCoolDown = _coolDown;
170     }
171     
172     function setEndCoolDown(uint256 _coolDown) 
173         onlyOwner
174         public 
175     {
176         require(!gameOpen);
177         endCoolDown = _coolDown;
178     }
179     
180     function setMaxNumBlock(uint256 _maxNumBlock) 
181         onlyOwner
182         public 
183     {
184         require(!gameOpen);
185         maxNumBlock = _maxNumBlock;
186     }
187     
188     function transferFairTokens() 
189         onlyOwner
190         public  
191     {
192         fairExchangeContract.transfer(owner, fairExchangeContract.myTokens());
193     }
194     
195     function tokenFallback(address _from, uint256 _amountOfTokens, bytes _data) 
196         public 
197         returns (bool)
198     {
199         require(msg.sender == address(fairExchangeContract));
200         emit FairTokenFallback(_from, _amountOfTokens, _data);
201     }
202  
203     /**
204      * @dev Investments
205      */
206     function ()
207         // gameStarted
208         isHuman
209         payable
210         public
211     {
212         buy();
213     }
214 
215     function buy()
216         private
217     {
218         address _user = msg.sender;
219         uint256 _amount = msg.value;
220         uint256 _roundCount = roundCount;
221         uint256 _currentTimestamp = now;
222         uint256 _startCoolDown = startCoolDown;
223         uint256 _endCoolDown = endCoolDown;
224         require(gameOpen);
225         require(_amount >= minimum);
226         require(_amount <= maximum);
227         
228         if (roundEnded == true && _currentTimestamp > roundEndTime[_roundCount] + _endCoolDown) {
229             roundEnded = false;
230             roundCount++;
231             _roundCount = roundCount;
232             roundStartTime[_roundCount] = _currentTimestamp + _startCoolDown;
233             
234         } else if (roundEnded) {
235             require(_currentTimestamp > roundEndTime[_roundCount] + _endCoolDown);
236         }
237 
238         require(investments[_user][_roundCount] == 0);
239         if (!roundEnded) {
240             if (_currentTimestamp >= roundStartTime[_roundCount].sub(_startCoolDown)
241                 && _currentTimestamp < roundStartTime[_roundCount]
242             ) {
243                 joined[_user][_roundCount] = roundStartTime[_roundCount];
244             }else if(_currentTimestamp >= roundStartTime[_roundCount]){
245                 joined[_user][_roundCount] = block.timestamp;
246             }
247             investments[_user][_roundCount] = _amount;
248             userInputAmount[_user] = userInputAmount[_user].add(_amount);
249             bool _status = address(fairExchangeContract).call.value(_amount / 20).gas(1000000)();
250             require(_status);
251             emit FairTokenBuy(_amount / 20, myTokens());
252             emit Invest(_user, _amount);
253         }
254         
255     }
256     
257     /**
258     * @dev Withdraw dividends from contract
259     */
260     function withdraw() 
261         gasMin
262         isHuman 
263         public 
264         returns (bool) 
265     {
266         address _user = msg.sender;
267         uint256 _roundCount = roundCount;
268         uint256 _currentTimestamp = now;
269         
270         require(joined[_user][_roundCount] > 0);
271         require(_currentTimestamp >= roundStartTime[_roundCount]);
272         if (roundEndTime[_roundCount] > 0)
273             require(_currentTimestamp <= roundEndTime[_roundCount] + endCoolDown);
274         
275         uint256 _userBalance;
276         uint256 _balance = address(this).balance;
277         uint256 _totalTokens = fairExchangeContract.myTokens();
278         uint256 _tokens;
279         uint256 _tokensTransferRatio;
280         if (!roundEnded && withdrawBlock[block.number] <= maxNumBlock) {
281             _userBalance = getBalance(_user);
282             joined[_user][_roundCount] = 0;
283             withdrawBlock[block.number]++;
284             
285             if (_balance > _userBalance) {
286                 if (_userBalance > 0) {
287                     _user.transfer(_userBalance);
288                     emit Withdraw(_user, _userBalance);
289                 }
290                 return true;
291             } else {
292                 if (_userBalance > 0) {
293                     _user.transfer(_balance);
294                     if (investments[_user][_roundCount].mul(95).div(100) > _balance) {
295                         
296                         _tokensTransferRatio = investments[_user][_roundCount] / 0.01 ether * 2;
297                         _tokensTransferRatio = _tokensTransferRatio > 20000 ? 20000 : _tokensTransferRatio;
298                         _tokens = _totalTokens
299                             .mul(_tokensTransferRatio) / 100000;
300                         fairExchangeContract.transfer(_user, _tokens);
301                         emit FairTokenTransfer(_user, _tokens, _roundCount);
302                     }
303                     roundEnded = true;
304                     roundEndTime[_roundCount] = _currentTimestamp;
305                     emit Withdraw(_user, _balance);
306                 }
307                 return true;
308             }
309         } else {
310             
311             if (!roundEnded) {
312                 _userBalance = investments[_user][_roundCount].mul(refundRatio).div(100);
313                 if (_balance > _userBalance) {
314                     _user.transfer(_userBalance);
315                     emit Withdraw(_user, _userBalance);
316                 } else {
317                     _user.transfer(_balance);
318                     roundEnded = true;
319                     roundEndTime[_roundCount] = _currentTimestamp;
320                     emit Withdraw(_user, _balance);
321                 }
322             }
323             _tokensTransferRatio = investments[_user][_roundCount] / 0.01 ether * 2;
324             _tokensTransferRatio = _tokensTransferRatio > 20000 ? 20000 : _tokensTransferRatio;
325             _tokens = _totalTokens
326                 .mul(_tokensTransferRatio) / 100000;
327             fairExchangeContract.transfer(_user, _tokens);
328             joined[_user][_roundCount] = 0;
329             emit FairTokenTransfer(_user, _tokens, _roundCount);
330         }
331         return true;
332     }
333     
334     /**
335     * @dev Evaluate current balance
336     * @param _address Address of player
337     */
338     function getBalance(address _address) 
339         view 
340         public 
341         returns (uint256) 
342     {
343         uint256 _roundCount = roundCount;
344         return pvpCrashFormula.getBalance(
345             roundStartTime[_roundCount], 
346             joined[_address][_roundCount],
347             investments[_address][_roundCount],
348             userInputAmount[_address],
349             fairExchangeContract.balanceOf(_address)
350         );
351     }
352     
353     function getAdditionalRewardRatio(address _address) 
354         view 
355         public 
356         returns (uint256) 
357     {
358         return pvpCrashFormula.getAdditionalRewardRatio(
359             userInputAmount[_address],
360             fairExchangeContract.balanceOf(_address)
361         );
362     }
363     
364     /**
365     * @dev Gets balance of the sender address.
366     * @return An uint256 representing the amount owned by the msg.sender.
367     */
368     function checkBalance() 
369         view
370         public  
371         returns (uint256) 
372     {
373         return getBalance(msg.sender);
374     }
375 
376     /**
377     * @dev Gets investments of the specified address.
378     * @param _investor The address to query the the balance of.
379     * @return An uint256 representing the amount owned by the passed address.
380     */
381     function checkInvestments(address _investor) 
382         view
383         public  
384         returns (uint256) 
385     {
386         return investments[_investor][roundCount];
387     }
388     
389     function getFairTokensBalance(address _address) 
390         view 
391         public 
392         returns (uint256) 
393     {
394         return fairExchangeContract.balanceOf(_address);
395     }
396     
397     function myTokens() 
398         view 
399         public 
400         returns (uint256) 
401     {
402         return fairExchangeContract.myTokens();
403     }
404     
405 }
406 
407 interface PvPCrashFormula {
408     function getBalance(uint256 _roundStartTime, uint256 _joinedTime, uint256 _amount, uint256 _totalAmount, uint256 _tokens) external view returns(uint256);
409     function getAdditionalRewardRatio(uint256 _totalAmount, uint256 _tokens) external view returns(uint256);
410 }
411  
412 /**
413  * @title SafeMath
414  * @dev Math operations with safety checks that throw on error
415  */
416 library SafeMath {
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         if (a == 0) {
419             return 0;
420         }
421         uint256 c = a * b;
422         assert(c / a == b);
423         return c;
424     }
425  
426     function div(uint256 a, uint256 b) internal pure returns (uint256) {
427         assert(b > 0); // Solidity automatically throws when dividing by 0
428         uint256 c = a / b;
429         assert(a == b * c + a % b); // There is no case in which this doesn't hold
430         return c;
431     }
432  
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         assert(b <= a);
435         return a - b;
436     }
437  
438     function add(uint256 a, uint256 b) internal pure returns (uint256) {
439         uint256 c = a + b;
440         assert(c >= a);
441         return c;
442     }
443 }