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
55     string public constant symbol = "RMC";
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
72     // Soft capacity = 166 666 RMC = 500 ETH
73     uint public constant SOFT_CAPACITY = 166666 * BASE;
74     // Hard capacity = 600 000 RMC = 1875 ETH
75     uint public constant TOKENS_SUPPLY = 600000 * BASE;
76     // Amount of bounty reward
77     uint public constant BOUNTY_SUPPLY = 350000 * BASE;
78     // Total supply
79     uint public constant totalSupply = TOKENS_SUPPLY + BOUNTY_SUPPLY;
80     
81     // 1 RMC = 0.003 ETH for first 200 000 RMC
82     // 1 RMC = 0.003125 ETH for second 200 000 RMC
83     // 1 RMC = 0.00325 ETH for third 200 000 RMC
84     uint public constant TOKEN_PRICE = 3000000000000000;
85     uint tokenAmount1 = 200000 * BASE;
86     uint tokenAmount2 = 200000 * BASE;
87     uint tokenAmount3 = 200000 * BASE;
88     uint tokenPriceMultiply1 = 1;
89     uint tokenPriceDivide1 = 1;
90     uint tokenPriceMultiply2 = 1041667;
91     uint tokenPriceDivide2 = 1000000;
92     uint tokenPriceMultiply3 = 1083333;
93     uint tokenPriceDivide3 = 1000000;
94     
95     uint[] public tokenPriceMultiplies;
96     uint[] public tokenPriceDivides;
97     uint[] public tokenAmounts;
98     
99     // ETH balances of accounts
100     mapping(address => uint) public ethBalances;
101     uint[] public prices;
102     uint[] public amounts;
103     
104     mapping(address => uint) private balances;
105     
106     // 2018.01.11 17:00 MSK
107     uint public constant defaultDeadline = 1515679200;
108     uint public deadline = defaultDeadline;
109     
110     // Is ICO frozen
111     bool public isIcoStopped = false;
112     
113     // Addresses of allowed tokens for buying 
114     address[] public allowedTokens;
115     // Amount of token
116     mapping(address => uint) public tokenAmount;
117     // Price of current token amount
118     mapping(address => uint) public tokenPrice;
119     
120     // Full users list
121     address[] public usersList;
122     mapping(address => bool) isUserInList;
123     // Number of users that have returned their money
124     uint numberOfUsersReturned = 0;
125     
126     // user => token[]
127     mapping(address => address[]) public userTokens;
128     //  user => token => amount
129     mapping(address => mapping(address => uint)) public userTokensValues;
130     
131     /*
132      * Events
133      */
134     
135     event BuyTokens(address indexed _user, uint _ethValue, uint _boughtTokens);
136     event BuyTokensWithTokens(address indexed _user, address indexed _token, uint _tokenValue, uint _boughtTokens);
137     event GiveReward(address indexed _to, uint _value);
138     
139     event IcoStoppedManually();
140     event IcoRunnedManually();
141     
142     event WithdrawEther(address indexed _escrow, uint _ethValue);
143     event WithdrawToken(address indexed _escrow, address indexed _token, uint _value);
144     event ReturnEthersFor(address indexed _user, uint _value);
145     event ReturnTokensFor(address indexed _user, address indexed _token, uint _value);
146     
147     event AddToken(address indexed _token, uint _amount, uint _price);
148     event RemoveToken(address indexed _token);
149     
150     event MoveTokens(address indexed _from, address indexed _to, uint _value);
151     
152     event Transfer(address indexed _from, address indexed _to, uint _value);
153     event Approval(address indexed _owner, address indexed _spender, uint _value);
154     
155     /*
156      * Modifiers
157      */
158     
159     modifier onlyManager {
160         assert(msg.sender == manager || msg.sender == reserveManager);
161         _;
162     }
163     modifier onlyManagerOrContract {
164         assert(msg.sender == manager || msg.sender == reserveManager || msg.sender == address(this));
165         _;
166     }
167     modifier IcoIsActive {
168         assert(isIcoActive());
169         _;
170     }
171     
172     
173     /// @dev Constructor of PreIco.
174     /// @param _manager Address of manager
175     /// @param _reserveManager Address of reserve manager
176     /// @param _escrow Address of escrow
177     /// @param _reserveEscrow Address of reserve escrow
178     /// @param _deadline ICO deadline timestamp. If is 0, sets 1515679200
179     function PreIco(address _manager, address _reserveManager, address _escrow, address _reserveEscrow, uint _deadline) public {
180         assert(_manager != 0x0);
181         assert(_reserveManager != 0x0);
182         assert(_escrow != 0x0);
183         assert(_reserveEscrow != 0x0);
184         
185         manager = _manager;
186         reserveManager = _reserveManager;
187         escrow = _escrow;
188         reserveEscrow = _reserveEscrow;
189         
190         if (_deadline != 0) {
191             deadline = _deadline;
192         }
193         
194         tokenPriceMultiplies.push(tokenPriceMultiply1);
195         tokenPriceMultiplies.push(tokenPriceMultiply2);
196         tokenPriceMultiplies.push(tokenPriceMultiply3);
197         tokenPriceDivides.push(tokenPriceDivide1);
198         tokenPriceDivides.push(tokenPriceDivide2);
199         tokenPriceDivides.push(tokenPriceDivide3);
200         tokenAmounts.push(tokenAmount1);
201         tokenAmounts.push(tokenAmount2);
202         tokenAmounts.push(tokenAmount3);
203     }
204     
205     /// @dev Returns token balance of user. 1 token = 1/10^18 RMC
206     /// @param _user Address of user
207     function balanceOf(address _user) public returns(uint balance) {
208         return balances[_user];
209     }
210     
211     /// @dev Returns, is ICO enabled
212     function isIcoActive() public returns(bool isActive) {
213         return !isIcoStopped && now < deadline;
214     }
215     
216     /// @dev Returns, is SoftCap reached
217     function isIcoSuccessful() public returns(bool isSuccessful) {
218         return tokensSupplied >= SOFT_CAPACITY;
219     }
220     
221     /// @dev Calculates number of tokens RMC for buying with custom price of token
222     /// @param _amountOfToken Amount of RMC token
223     /// @param _priceAmountOfToken Price of amount of RMC
224     /// @param _value Amount of custom token
225     function getTokensAmount(uint _amountOfToken, uint _priceAmountOfToken,  uint _value) private returns(uint tokensToBuy) {
226         uint currentStep;
227         uint tokensRemoved = tokensSupplied;
228         for (currentStep = 0; currentStep < tokenAmounts.length; currentStep++) {
229             if (tokensRemoved >= tokenAmounts[currentStep]) {
230                 tokensRemoved -= tokenAmounts[currentStep];
231             } else {
232                 break;
233             }
234         }
235         assert(currentStep < tokenAmounts.length);
236         
237         uint result = 0;
238         
239         for (; currentStep <= tokenAmounts.length; currentStep++) {
240             assert(currentStep < tokenAmounts.length);
241             
242             uint tokenOnStepLeft = tokenAmounts[currentStep] - tokensRemoved;
243             tokensRemoved = 0;
244             uint howManyTokensCanBuy = _value 
245                     * _amountOfToken / _priceAmountOfToken 
246                     * tokenPriceDivides[currentStep] / tokenPriceMultiplies[currentStep];
247             
248             if (howManyTokensCanBuy > tokenOnStepLeft) {
249                 result = add(result, tokenOnStepLeft);
250                 uint spent = tokenOnStepLeft 
251                     * _priceAmountOfToken / _amountOfToken 
252                     * tokenPriceMultiplies[currentStep] / tokenPriceDivides[currentStep];
253                 if (_value <= spent) {
254                     break;
255                 }
256                 _value -= spent;
257                 tokensRemoved = 0;
258             } else {
259                 result = add(result, howManyTokensCanBuy);
260                 break;
261             }
262         }
263         
264         return result;
265     }
266     
267     /// @dev Calculates number of tokens RMC for buying with ETH
268     /// @param _value Amount of ETH token
269     function getTokensAmountWithEth(uint _value) private returns(uint tokensToBuy) {
270         return getTokensAmount(BASE, TOKEN_PRICE, _value);
271     }
272     
273     /// @dev Calculates number of tokens RMC for buying with ERC-20 token
274     /// @param _token Address of ERC-20 token
275     /// @param _tokenValue Amount of ETH token
276     function getTokensAmountByTokens(address _token, uint _tokenValue) private returns(uint tokensToBuy) {
277         assert(tokenPrice[_token] > 0);
278         return getTokensAmount(tokenPrice[_token], tokenAmount[_token], _tokenValue);
279     }
280     
281     /// @dev Solds tokens for user by ETH
282     /// @param _user Address of user which buys token
283     /// @param _value Amount of ETH. 1 _value = 1/10^18 ETH
284     function buyTokens(address _user, uint _value) private IcoIsActive {
285         uint boughtTokens = getTokensAmountWithEth(_value);
286         burnTokens(boughtTokens);
287         
288         balances[_user] = add(balances[_user], boughtTokens);
289         addUserToList(_user);
290         BuyTokens(_user, _value, boughtTokens);
291     }
292     
293     /// @dev Makes ERC-20 token sellable
294     /// @param _token Address of ERC-20 token
295     /// @param _amount Amount of current token
296     /// @param _price Price of _amount of token
297     function addToken(address _token, uint _amount, uint _price) onlyManager public {
298         assert(_token != 0x0);
299         assert(_amount > 0);
300         assert(_price > 0);
301         
302         bool isNewToken = true;
303         for (uint i = 0; i < allowedTokens.length; i++) {
304             if (allowedTokens[i] == _token) {
305                 isNewToken = false;
306                 break;
307             }
308         }
309         if (isNewToken) {
310             allowedTokens.push(_token);
311         }
312         
313         tokenPrice[_token] = _price;
314         tokenAmount[_token] = _amount;
315     }
316     
317     /// @dev Makes ERC-20 token not sellable
318     /// @param _token Address of ERC-20 token
319     function removeToken(address _token) onlyManager public {
320         for (uint i = 0; i < allowedTokens.length; i++) {
321             if (_token == allowedTokens[i]) {
322                 if (i < allowedTokens.length - 1) {
323                     allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
324                 }
325                 allowedTokens[allowedTokens.length - 1] = 0x0;
326                 allowedTokens.length--;
327                 break;
328             }
329         }
330     
331         tokenPrice[_token] = 0;
332         tokenAmount[_token] = 0;
333     }
334     
335     /// @dev add user to usersList
336     /// @param _user Address of user
337     function addUserToList(address _user) private {
338         if (!isUserInList[_user]) {
339             isUserInList[_user] = true;
340             usersList.push(_user);
341         }
342     }
343     
344     /// @dev Makes amount of tokens not purchasable
345     /// @param _amount Amount of RMC tokens
346     function burnTokens(uint _amount) private {
347         assert(add(tokensSupplied, _amount) <= TOKENS_SUPPLY);
348         tokensSupplied = add(tokensSupplied, _amount);
349     }
350     
351     /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens
352     /// @param _token Address of ERC-20 token
353     function buyWithTokens(address _token) public {
354         buyWithTokensBy(msg.sender, _token);
355     }
356     
357     /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens. Can be called by anyone
358     /// @param _user Address of user
359     /// @param _token Address of ERC-20 token
360     function buyWithTokensBy(address _user, address _token) public IcoIsActive {
361         // Checks whether the token is allowed
362         assert(tokenPrice[_token] > 0);
363         
364         AbstractToken token = AbstractToken(_token);
365         uint tokensToSend = token.allowance(_user, address(this));
366         assert(tokensToSend > 0);
367         
368         uint boughtTokens = getTokensAmountByTokens(_token, tokensToSend);
369         burnTokens(boughtTokens);
370         balances[_user] = add(balances[_user], boughtTokens);
371         
372         uint prevBalance = token.balanceOf(address(this));
373         assert(token.transferFrom(_user, address(this), tokensToSend));
374         assert(token.balanceOf(address(this)) - prevBalance == tokensToSend);
375         
376         userTokensValues[_user][_token] = add(userTokensValues[_user][_token], tokensToSend);
377         
378         addTokenToUser(_user, _token);
379         addUserToList(_user);
380         BuyTokensWithTokens(_user, _token, tokensToSend, boughtTokens);
381     }
382     
383     /// @dev Makes amount of tokens returnable for user. If _buyTokens equals true, buy tokens 
384     /// @param _user Address of user
385     /// @param _token Address of ERC-20 token
386     /// @param _tokenValue Amount of ERC-20 token
387     /// @param _buyTokens If true, buys tokens for this sum
388     function addTokensToReturn(address _user, address _token, uint _tokenValue, bool _buyTokens) public onlyManager {
389         // Checks whether the token is allowed
390         assert(tokenPrice[_token] > 0);
391         
392         if (_buyTokens) {
393             uint boughtTokens = getTokensAmountByTokens(_token, _tokenValue);
394             burnTokens(boughtTokens);
395             balances[_user] = add(balances[_user], boughtTokens);
396             BuyTokensWithTokens(_user, _token, _tokenValue, boughtTokens);
397         }
398         
399         userTokensValues[_user][_token] = add(userTokensValues[_user][_token], _tokenValue);
400         addTokenToUser(_user, _token);
401         addUserToList(_user);
402     }
403     
404     
405     /// @dev Adds ERC-20 tokens to user's token list
406     /// @param _user Address of user
407     /// @param _token Address of ERC-20 token
408     function addTokenToUser(address _user, address _token) private {
409         for (uint i = 0; i < userTokens[_user].length; i++) {
410             if (userTokens[_user][i] == _token) {
411                 return;
412             }
413         }
414         userTokens[_user].push(_token);
415     }
416     
417     /// @dev Returns ether and tokens to user. Can be called only if ICO is ended and SoftCap is not reached
418     function returnFunds() public {
419         assert(!isIcoSuccessful() && !isIcoActive());
420         
421         returnFundsFor(msg.sender);
422     }
423     
424     /// @dev Moves tokens from one user to another. Can be called only by manager. This function added for users that send ether by stock exchanges
425     function moveIcoTokens(address _from, address _to, uint _value) public onlyManager {
426         balances[_from] = sub(balances[_from], _value);
427         balances[_to] = add(balances[_to], _value);
428         
429         MoveTokens(_from, _to, _value);
430     }
431     
432     /// @dev Returns ether and tokens to user. Can be called only by manager or contract
433     /// @param _user Address of user
434     function returnFundsFor(address _user) public onlyManagerOrContract returns(bool) {
435         if (ethBalances[_user] > 0) {
436             if (_user.send(ethBalances[_user])) {
437                 ReturnEthersFor(_user, ethBalances[_user]);
438                 ethBalances[_user] = 0;
439             }
440         }
441         
442         for (uint i = 0; i < userTokens[_user].length; i++) {
443             address tokenAddress = userTokens[_user][i];
444             uint userTokenValue = userTokensValues[_user][tokenAddress];
445             if (userTokenValue > 0) {
446                 AbstractToken token = AbstractToken(tokenAddress);
447                 if (token.transfer(_user, userTokenValue)) {
448                     ReturnTokensFor(_user, tokenAddress, userTokenValue);
449                     userTokensValues[_user][tokenAddress] = 0;
450                 }
451             }
452         }
453         
454         balances[_user] = 0;
455     }
456     
457     /// @dev Returns ether and tokens to list of users. Can be called only by manager
458     /// @param _users Array of addresses of users
459     function returnFundsForMultiple(address[] _users) public onlyManager {
460         for (uint i = 0; i < _users.length; i++) {
461             returnFundsFor(_users[i]);
462         }
463     }
464     
465     /// @dev Returns ether and tokens to 50 users. Can be called only by manager
466     function returnFundsForAll() public onlyManager {
467         assert(!isIcoActive() && !isIcoSuccessful());
468         
469         uint first = numberOfUsersReturned;
470         uint last  = (first + 50 < usersList.length) ? first + 50 : usersList.length;
471         
472         for (uint i = first; i < last; i++) {
473             returnFundsFor(usersList[i]);
474         }
475         
476         numberOfUsersReturned = last;
477     }
478     
479     /// @dev Withdraws ether and tokens to _escrow if SoftCap is reached
480     /// @param _escrow Address of escrow
481     function withdrawEtherTo(address _escrow) private {
482         assert(isIcoSuccessful());
483         
484         if (this.balance > 0) {
485             if (_escrow.send(this.balance)) {
486                 WithdrawEther(_escrow, this.balance);
487             }
488         }
489         
490         for (uint i = 0; i < allowedTokens.length; i++) {
491             AbstractToken token = AbstractToken(allowedTokens[i]);
492             uint tokenBalance = token.balanceOf(address(this));
493             if (tokenBalance > 0) {
494                 if (token.transfer(_escrow, tokenBalance)) {
495                     WithdrawToken(_escrow, address(token), tokenBalance);
496                 }
497             }
498         }
499     }
500     
501     /// @dev Withdraw ether and tokens to escrow. Can be called only by manager
502     function withdrawEther() public onlyManager {
503         withdrawEtherTo(escrow);
504     }
505     
506     /// @dev Withdraw ether and tokens to reserve escrow. Can be called only by manager
507     function withdrawEtherToReserveEscrow() public onlyManager {
508         withdrawEtherTo(reserveEscrow);
509     }
510     
511     /// @dev Enables disabled ICO. Can be called only by manager
512     function runIco() public onlyManager {
513         assert(isIcoStopped);
514         isIcoStopped = false;
515         IcoRunnedManually();
516     }
517     
518     /// @dev Disables ICO. Can be called only by manager
519     function stopIco() public onlyManager {
520         isIcoStopped = true;
521         IcoStoppedManually();
522     }
523     
524     /// @dev Fallback function. Buy RMC tokens on sending ether
525     function () public payable {
526         buyTokens(msg.sender, msg.value);
527     }
528     
529     /// @dev Gives bounty reward to user. Can be called only by manager
530     /// @param _to Address of user
531     /// @param _amount Amount of bounty
532     function giveReward(address _to, uint _amount) public onlyManager {
533         assert(_to != 0x0);
534         assert(_amount > 0);
535         assert(add(bountySupplied, _amount) <= BOUNTY_SUPPLY);
536         
537         bountySupplied = add(bountySupplied, _amount);
538         balances[_to] = add(balances[_to], _amount);
539         
540         GiveReward(_to, _amount);
541     }
542     
543     /// Adds other ERC-20 functions
544     function transfer(address _to, uint _value) public returns (bool success) {
545         return false;
546     }
547     
548     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
549         return false;
550     }
551     
552     function approve(address _spender, uint _value) public returns (bool success) {
553         return false;
554     }
555     
556     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
557         return 0;
558     }
559 }