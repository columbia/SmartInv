1 pragma solidity ^0.4.18;
2 
3 contract AbstractToken {
4     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
5     function totalSupply() public constant returns (uint256) {}
6     function balanceOf(address owner) public constant returns (uint256 balance);
7     function transfer(address to, uint256 value) public returns (bool success);
8     function transferFrom(address from, address to, uint256 value) public returns (bool success);
9     function approve(address spender, uint256 value) public returns (bool success);
10     function allowance(address owner, address spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14     event Issuance(address indexed to, uint256 value);
15 }
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 contract SafeMath {
21   function mul(uint256 a, uint256 b) constant internal returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) constant internal returns (uint256) {
28     assert(b != 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) constant internal returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) constant internal returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
46       return div(mul(number, numerator), denominator);
47   }
48 }
49 
50 contract PreIco is SafeMath {
51     /*
52      * PreIco meta data
53      */
54     string public constant name = "Remechain Presale Token";
55     string public constant symbol = "iRMC";
56     uint public constant decimals = 18;
57 
58     // addresses of managers
59     address public manager;
60     address public reserveManager;
61     // addresses of escrows
62     address public escrow;
63     address public reserveEscrow;
64 
65     // BASE = 10^18
66     uint constant BASE = 1000000000000000000;
67 
68     // amount of supplied tokens
69     uint public tokensSupplied = 0;
70     // amount of supplied bounty reward
71     uint public bountySupplied = 0;
72     // Soft capacity = 6250 ETH
73     uint public constant SOFT_CAPACITY = 2000000 * BASE;
74     // Hard capacity = 18750 ETH
75     uint public constant TOKENS_SUPPLY = 6000000 * BASE;
76     // Amount of bounty reward
77     uint public constant BOUNTY_SUPPLY = 350000 * BASE;
78     // Total supply
79     uint public constant totalSupply = TOKENS_SUPPLY + BOUNTY_SUPPLY;
80 
81     // 1 RMC = 0.003125 ETH for  600 000 000 RMC
82 
83     uint public constant TOKEN_PRICE = 3125000000000000;
84     uint tokenAmount1 = 6000000 * BASE;
85 
86     uint tokenPriceMultiply1 = 1;
87     uint tokenPriceDivide1 = 1;
88 
89     uint[] public tokenPriceMultiplies;
90     uint[] public tokenPriceDivides;
91     uint[] public tokenAmounts;
92 
93     // ETH balances of accounts
94     mapping(address => uint) public ethBalances;
95     uint[] public prices;
96     uint[] public amounts;
97 
98     mapping(address => uint) private balances;
99 
100     // 2018.02.25 17:00 MSK
101     uint public constant defaultDeadline = 1519567200;
102     uint public deadline = defaultDeadline;
103 
104     // Is ICO frozen
105     bool public isIcoStopped = false;
106 
107     // Addresses of allowed tokens for buying
108     address[] public allowedTokens;
109     // Amount of token
110     mapping(address => uint) public tokenAmount;
111     // Price of current token amount
112     mapping(address => uint) public tokenPrice;
113 
114     // Full users list
115     address[] public usersList;
116     mapping(address => bool) isUserInList;
117     // Number of users that have returned their money
118     uint numberOfUsersReturned = 0;
119 
120     // user => token[]
121     mapping(address => address[]) public userTokens;
122     //  user => token => amount
123     mapping(address => mapping(address => uint)) public userTokensValues;
124 
125     /*
126      * Events
127      */
128 
129     event BuyTokens(address indexed _user, uint _ethValue, uint _boughtTokens);
130     event BuyTokensWithTokens(address indexed _user, address indexed _token, uint _tokenValue, uint _boughtTokens);
131     event GiveReward(address indexed _to, uint _value);
132 
133     event IcoStoppedManually();
134     event IcoRunnedManually();
135 
136     event WithdrawEther(address indexed _escrow, uint _ethValue);
137     event WithdrawToken(address indexed _escrow, address indexed _token, uint _value);
138     event ReturnEthersFor(address indexed _user, uint _value);
139     event ReturnTokensFor(address indexed _user, address indexed _token, uint _value);
140 
141     event AddToken(address indexed _token, uint _amount, uint _price);
142     event RemoveToken(address indexed _token);
143 
144     event MoveTokens(address indexed _from, address indexed _to, uint _value);
145 
146     event Transfer(address indexed _from, address indexed _to, uint _value);
147     event Approval(address indexed _owner, address indexed _spender, uint _value);
148 
149     /*
150      * Modifiers
151      */
152 
153     modifier onlyManager {
154         assert(msg.sender == manager || msg.sender == reserveManager);
155         _;
156     }
157     modifier onlyManagerOrContract {
158         assert(msg.sender == manager || msg.sender == reserveManager || msg.sender == address(this));
159         _;
160     }
161     modifier IcoIsActive {
162         assert(isIcoActive());
163         _;
164     }
165 
166 
167     /// @dev Constructor of PreIco.
168     /// @param _manager Address of manager
169     /// @param _reserveManager Address of reserve manager
170     /// @param _escrow Address of escrow
171     /// @param _reserveEscrow Address of reserve escrow
172     /// @param _deadline ICO deadline timestamp. If is 0, sets 1515679200
173     function PreIco(address _manager, address _reserveManager, address _escrow, address _reserveEscrow, uint _deadline) public {
174         assert(_manager != 0x0);
175         assert(_reserveManager != 0x0);
176         assert(_escrow != 0x0);
177         assert(_reserveEscrow != 0x0);
178 
179         manager = _manager;
180         reserveManager = _reserveManager;
181         escrow = _escrow;
182         reserveEscrow = _reserveEscrow;
183 
184         if (_deadline != 0) {
185             deadline = _deadline;
186         }
187         tokenPriceMultiplies.push(tokenPriceMultiply1);
188         tokenPriceDivides.push(tokenPriceDivide1);
189         tokenAmounts.push(tokenAmount1);
190     }
191 
192     /// @dev Returns token balance of user. 1 token = 1/10^18 RMC
193     /// @param _user Address of user
194     function balanceOf(address _user) public returns(uint balance) {
195         return balances[_user];
196     }
197 
198     /// @dev Returns, is ICO enabled
199     function isIcoActive() public returns(bool isActive) {
200         return !isIcoStopped && now < deadline;
201     }
202 
203     /// @dev Returns, is SoftCap reached
204     function isIcoSuccessful() public returns(bool isSuccessful) {
205         return tokensSupplied >= SOFT_CAPACITY;
206     }
207 
208     /// @dev Calculates number of tokens RMC for buying with custom price of token
209     /// @param _amountOfToken Amount of RMC token
210     /// @param _priceAmountOfToken Price of amount of RMC
211     /// @param _value Amount of custom token
212     function getTokensAmount(uint _amountOfToken, uint _priceAmountOfToken,  uint _value) private returns(uint tokensToBuy) {
213         uint currentStep;
214         uint tokensRemoved = tokensSupplied;
215         for (currentStep = 0; currentStep < tokenAmounts.length; currentStep++) {
216             if (tokensRemoved >= tokenAmounts[currentStep]) {
217                 tokensRemoved -= tokenAmounts[currentStep];
218             } else {
219                 break;
220             }
221         }
222         assert(currentStep < tokenAmounts.length);
223 
224         uint result = 0;
225 
226         for (; currentStep <= tokenAmounts.length; currentStep++) {
227             assert(currentStep < tokenAmounts.length);
228 
229             uint tokenOnStepLeft = tokenAmounts[currentStep] - tokensRemoved;
230             tokensRemoved = 0;
231             uint howManyTokensCanBuy = _value
232                     * _amountOfToken / _priceAmountOfToken
233                     * tokenPriceDivides[currentStep] / tokenPriceMultiplies[currentStep];
234 
235             if (howManyTokensCanBuy > tokenOnStepLeft) {
236                 result = add(result, tokenOnStepLeft);
237                 uint spent = tokenOnStepLeft
238                     * _priceAmountOfToken / _amountOfToken
239                     * tokenPriceMultiplies[currentStep] / tokenPriceDivides[currentStep];
240                 if (_value <= spent) {
241                     break;
242                 }
243                 _value -= spent;
244                 tokensRemoved = 0;
245             } else {
246                 result = add(result, howManyTokensCanBuy);
247                 break;
248             }
249         }
250 
251         return result;
252     }
253 
254     /// @dev Calculates number of tokens RMC for buying with ETH
255     /// @param _value Amount of ETH token
256     function getTokensAmountWithEth(uint _value) private returns(uint tokensToBuy) {
257         return getTokensAmount(BASE, TOKEN_PRICE, _value);
258     }
259 
260     /// @dev Calculates number of tokens RMC for buying with ERC-20 token
261     /// @param _token Address of ERC-20 token
262     /// @param _tokenValue Amount of ETH token
263     function getTokensAmountByTokens(address _token, uint _tokenValue) private returns(uint tokensToBuy) {
264         assert(tokenPrice[_token] > 0);
265         return getTokensAmount(tokenPrice[_token], tokenAmount[_token], _tokenValue);
266     }
267 
268     /// @dev Solds tokens for user by ETH
269     /// @param _user Address of user which buys token
270     /// @param _value Amount of ETH. 1 _value = 1/10^18 ETH
271     function buyTokens(address _user, uint _value) private IcoIsActive {
272         uint boughtTokens = getTokensAmountWithEth(_value);
273         burnTokens(boughtTokens);
274 
275         balances[_user] = add(balances[_user], boughtTokens);
276         addUserToList(_user);
277         BuyTokens(_user, _value, boughtTokens);
278     }
279 
280     /// @dev Makes ERC-20 token sellable
281     /// @param _token Address of ERC-20 token
282     /// @param _amount Amount of current token
283     /// @param _price Price of _amount of token
284     function addToken(address _token, uint _amount, uint _price) onlyManager public {
285         assert(_token != 0x0);
286         assert(_amount > 0);
287         assert(_price > 0);
288 
289         bool isNewToken = true;
290         for (uint i = 0; i < allowedTokens.length; i++) {
291             if (allowedTokens[i] == _token) {
292                 isNewToken = false;
293                 break;
294             }
295         }
296         if (isNewToken) {
297             allowedTokens.push(_token);
298         }
299 
300         tokenPrice[_token] = _price;
301         tokenAmount[_token] = _amount;
302     }
303 
304     /// @dev Makes ERC-20 token not sellable
305     /// @param _token Address of ERC-20 token
306     function removeToken(address _token) onlyManager public {
307         for (uint i = 0; i < allowedTokens.length; i++) {
308             if (_token == allowedTokens[i]) {
309                 if (i < allowedTokens.length - 1) {
310                     allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
311                 }
312                 allowedTokens[allowedTokens.length - 1] = 0x0;
313                 allowedTokens.length--;
314                 break;
315             }
316         }
317 
318         tokenPrice[_token] = 0;
319         tokenAmount[_token] = 0;
320     }
321 
322     /// @dev add user to usersList
323     /// @param _user Address of user
324     function addUserToList(address _user) private {
325         if (!isUserInList[_user]) {
326             isUserInList[_user] = true;
327             usersList.push(_user);
328         }
329     }
330 
331     /// @dev Makes amount of tokens not purchasable
332     /// @param _amount Amount of RMC tokens
333     function burnTokens(uint _amount) private {
334         assert(add(tokensSupplied, _amount) <= TOKENS_SUPPLY);
335         tokensSupplied = add(tokensSupplied, _amount);
336     }
337 
338     /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens
339     /// @param _token Address of ERC-20 token
340     function buyWithTokens(address _token) public {
341         buyWithTokensBy(msg.sender, _token);
342     }
343 
344     /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens. Can be called by anyone
345     /// @param _user Address of user
346     /// @param _token Address of ERC-20 token
347     function buyWithTokensBy(address _user, address _token) public IcoIsActive {
348         // Checks whether the token is allowed
349         assert(tokenPrice[_token] > 0);
350 
351         AbstractToken token = AbstractToken(_token);
352         uint tokensToSend = token.allowance(_user, address(this));
353         assert(tokensToSend > 0);
354 
355         uint boughtTokens = getTokensAmountByTokens(_token, tokensToSend);
356         burnTokens(boughtTokens);
357         balances[_user] = add(balances[_user], boughtTokens);
358 
359         uint prevBalance = token.balanceOf(address(this));
360         assert(token.transferFrom(_user, address(this), tokensToSend));
361         assert(token.balanceOf(address(this)) - prevBalance == tokensToSend);
362 
363         userTokensValues[_user][_token] = add(userTokensValues[_user][_token], tokensToSend);
364 
365         addTokenToUser(_user, _token);
366         addUserToList(_user);
367         BuyTokensWithTokens(_user, _token, tokensToSend, boughtTokens);
368     }
369 
370     /// @dev Makes amount of tokens returnable for user. If _buyTokens equals true, buy tokens
371     /// @param _user Address of user
372     /// @param _token Address of ERC-20 token
373     /// @param _tokenValue Amount of ERC-20 token
374     /// @param _buyTokens If true, buys tokens for this sum
375     function addTokensToReturn(address _user, address _token, uint _tokenValue, bool _buyTokens) public onlyManager {
376         // Checks whether the token is allowed
377         assert(tokenPrice[_token] > 0);
378 
379         if (_buyTokens) {
380             uint boughtTokens = getTokensAmountByTokens(_token, _tokenValue);
381             burnTokens(boughtTokens);
382             balances[_user] = add(balances[_user], boughtTokens);
383             BuyTokensWithTokens(_user, _token, _tokenValue, boughtTokens);
384         }
385 
386         userTokensValues[_user][_token] = add(userTokensValues[_user][_token], _tokenValue);
387         addTokenToUser(_user, _token);
388         addUserToList(_user);
389     }
390 
391 
392     /// @dev Adds ERC-20 tokens to user's token list
393     /// @param _user Address of user
394     /// @param _token Address of ERC-20 token
395     function addTokenToUser(address _user, address _token) private {
396         for (uint i = 0; i < userTokens[_user].length; i++) {
397             if (userTokens[_user][i] == _token) {
398                 return;
399             }
400         }
401         userTokens[_user].push(_token);
402     }
403 
404     /// @dev Returns ether and tokens to user. Can be called only if ICO is ended and SoftCap is not reached
405     function returnFunds() public {
406         assert(!isIcoSuccessful() && !isIcoActive());
407 
408         returnFundsFor(msg.sender);
409     }
410 
411     /// @dev Moves tokens from one user to another. Can be called only by manager. This function added for users that send ether by stock exchanges
412     function moveIcoTokens(address _from, address _to, uint _value) public onlyManager {
413         balances[_from] = sub(balances[_from], _value);
414         balances[_to] = add(balances[_to], _value);
415 
416         MoveTokens(_from, _to, _value);
417     }
418 
419     /// @dev Returns ether and tokens to user. Can be called only by manager or contract
420     /// @param _user Address of user
421     function returnFundsFor(address _user) public onlyManagerOrContract returns(bool) {
422         if (ethBalances[_user] > 0) {
423             if (_user.send(ethBalances[_user])) {
424                 ReturnEthersFor(_user, ethBalances[_user]);
425                 ethBalances[_user] = 0;
426             }
427         }
428 
429         for (uint i = 0; i < userTokens[_user].length; i++) {
430             address tokenAddress = userTokens[_user][i];
431             uint userTokenValue = userTokensValues[_user][tokenAddress];
432             if (userTokenValue > 0) {
433                 AbstractToken token = AbstractToken(tokenAddress);
434                 if (token.transfer(_user, userTokenValue)) {
435                     ReturnTokensFor(_user, tokenAddress, userTokenValue);
436                     userTokensValues[_user][tokenAddress] = 0;
437                 }
438             }
439         }
440 
441         balances[_user] = 0;
442     }
443 
444     /// @dev Returns ether and tokens to list of users. Can be called only by manager
445     /// @param _users Array of addresses of users
446     function returnFundsForMultiple(address[] _users) public onlyManager {
447         for (uint i = 0; i < _users.length; i++) {
448             returnFundsFor(_users[i]);
449         }
450     }
451 
452     /// @dev Returns ether and tokens to 50 users. Can be called only by manager
453     function returnFundsForAll() public onlyManager {
454         assert(!isIcoActive() && !isIcoSuccessful());
455 
456         uint first = numberOfUsersReturned;
457         uint last  = (first + 50 < usersList.length) ? first + 50 : usersList.length;
458 
459         for (uint i = first; i < last; i++) {
460             returnFundsFor(usersList[i]);
461         }
462 
463         numberOfUsersReturned = last;
464     }
465 
466     /// @dev Withdraws ether and tokens to _escrow if SoftCap is reached
467     /// @param _escrow Address of escrow
468     function withdrawEtherTo(address _escrow) private {
469         assert(isIcoSuccessful());
470 
471         if (this.balance > 0) {
472             if (_escrow.send(this.balance)) {
473                 WithdrawEther(_escrow, this.balance);
474             }
475         }
476 
477         for (uint i = 0; i < allowedTokens.length; i++) {
478             AbstractToken token = AbstractToken(allowedTokens[i]);
479             uint tokenBalance = token.balanceOf(address(this));
480             if (tokenBalance > 0) {
481                 if (token.transfer(_escrow, tokenBalance)) {
482                     WithdrawToken(_escrow, address(token), tokenBalance);
483                 }
484             }
485         }
486     }
487 
488     /// @dev Withdraw ether and tokens to escrow. Can be called only by manager
489     function withdrawEther() public onlyManager {
490         withdrawEtherTo(escrow);
491     }
492 
493     /// @dev Withdraw ether and tokens to reserve escrow. Can be called only by manager
494     function withdrawEtherToReserveEscrow() public onlyManager {
495         withdrawEtherTo(reserveEscrow);
496     }
497 
498     /// @dev Enables disabled ICO. Can be called only by manager
499     function runIco() public onlyManager {
500         assert(isIcoStopped);
501         isIcoStopped = false;
502         IcoRunnedManually();
503     }
504 
505     /// @dev Disables ICO. Can be called only by manager
506     function stopIco() public onlyManager {
507         isIcoStopped = true;
508         IcoStoppedManually();
509     }
510 
511     /// @dev Fallback function. Buy RMC tokens on sending ether
512     function () public payable {
513         buyTokens(msg.sender, msg.value);
514     }
515 
516     /// @dev Gives bounty reward to user. Can be called only by manager
517     /// @param _to Address of user
518     /// @param _amount Amount of bounty
519     function giveReward(address _to, uint _amount) public onlyManager {
520         assert(_to != 0x0);
521         assert(_amount > 0);
522         assert(add(bountySupplied, _amount) <= BOUNTY_SUPPLY);
523 
524         bountySupplied = add(bountySupplied, _amount);
525         balances[_to] = add(balances[_to], _amount);
526 
527         GiveReward(_to, _amount);
528     }
529 
530     /// Adds other ERC-20 functions
531     function transfer(address _to, uint _value) public returns (bool success) {
532         return false;
533     }
534 
535     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
536         return false;
537     }
538 
539     function approve(address _spender, uint _value) public returns (bool success) {
540         return false;
541     }
542 
543     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
544         return 0;
545     }
546 }