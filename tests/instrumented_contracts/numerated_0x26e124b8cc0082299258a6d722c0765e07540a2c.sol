1 pragma solidity ^0.4.18;
2 
3 /*
4 Nodepower ICO crowdsale contract
5 BONUS SCHEDULE:
6         Bonus        start time               end time
7         45%     2017-12-31 23:59:59 - 2018-01-31 23:59:59 1517443199
8         40%     2018-02-01 00:00:00 - 2018-02-14 23:59:59 1518652799
9         30%     2018-02-15 00:00:00 - 2018-02-24 23:59:59 1519516799
10         20%     2018-02-25 00:00:00 - 2018-03-06 23:59:59 1520380799
11         15%     2018-03-07 00:00:00 - 2018-03-16 23:59:59 1521244799
12         10%     2018-03-17 00:00:00 - 2018-03-26 23:59:59 1522108799
13 
14 See official resource for details https://nodepower.io/
15 */
16 
17 /**
18  * @title ERC20Basic
19  * @dev Simpler version of ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/179
21  */
22 contract ERC20Basic {
23     uint256 public totalSupply;
24     function balanceOf(address who) public view returns (uint256);
25     function transfer(address to, uint256 value) public returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38         uint256 c = a * b;
39         assert(c / a == b);
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     /**
73     * @dev transfer token for a specified address
74     * @param _to The address to transfer to.
75     * @param _value The amount to be transferred.
76     */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         // SafeMath.sub will throw if there is not enough balance.
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint256 representing the amount owned by the passed address.
92     */
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104     function allowance(address owner, address spender) public view returns (uint256);
105     function transferFrom(address from, address to, uint256 value) public returns (bool);
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123     /**
124      * @dev Transfer tokens from one address to another
125      * @param _from address The address which you want to send tokens from
126      * @param _to address The address which you want to transfer to
127      * @param _value uint256 the amount of tokens to be transferred
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      *
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param _spender The address which will spend the funds.
149      * @param _value The amount of tokens to be spent.
150      */
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param _owner address The address which owns the funds.
160      * @param _spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166 
167     /**
168      * @dev Increase the amount of tokens that an owner allowed to a spender.
169      *
170      * approve should be called when allowed[_spender] == 0. To increment
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     /**
184      * @dev Decrease the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when allowed[_spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _subtractedValue The amount of tokens to decrease the allowance by.
192      */
193     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194         uint oldValue = allowed[msg.sender][_spender];
195         if (_subtractedValue > oldValue) {
196             allowed[msg.sender][_spender] = 0;
197         } else {
198             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199         }
200         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204 }
205 
206 contract NodeToken is StandardToken {
207     string public name = "NodePower";
208     string public symbol = "NODE";
209     uint8 public decimals = 2;
210     bool public mintingFinished = false;
211     mapping (address => bool) owners;
212     mapping (address => bool) minters;
213 
214     event Mint(address indexed to, uint256 amount);
215     event MintFinished();
216     event OwnerAdded(address indexed newOwner);
217     event OwnerRemoved(address indexed removedOwner);
218     event MinterAdded(address indexed newMinter);
219     event MinterRemoved(address indexed removedMinter);
220     event Burn(address indexed burner, uint256 value);
221 
222     function NodeToken() public {
223         owners[msg.sender] = true;
224     }
225 
226     /**
227      * @dev Function to mint tokens
228      * @param _to The address that will receive the minted tokens.
229      * @param _amount The amount of tokens to mint.
230      * @return A boolean that indicates if the operation was successful.
231      */
232     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
233         require(!mintingFinished);
234         totalSupply = totalSupply.add(_amount);
235         balances[_to] = balances[_to].add(_amount);
236         Mint(_to, _amount);
237         Transfer(address(0), _to, _amount);
238         return true;
239     }
240 
241     /**
242      * @dev Function to stop minting new tokens.
243      * @return True if the operation was successful.
244      */
245     function finishMinting() onlyOwner public returns (bool) {
246         require(!mintingFinished);
247         mintingFinished = true;
248         MintFinished();
249         return true;
250     }
251 
252     /**
253      * @dev Burns a specific amount of tokens.
254      * @param _value The amount of token to be burned.
255      */
256     function burn(uint256 _value) public {
257         require(_value <= balances[msg.sender]);
258         // no need to require value <= totalSupply, since that would imply the
259         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
260 
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         Burn(burner, _value);
265     }
266 
267     /**
268      * @dev Adds administrative role to address
269      * @param _address The address that will get administrative privileges
270      */
271     function addOwner(address _address) onlyOwner public {
272         owners[_address] = true;
273         OwnerAdded(_address);
274     }
275 
276     /**
277      * @dev Removes administrative role from address
278      * @param _address The address to remove administrative privileges from
279      */
280     function delOwner(address _address) onlyOwner public {
281         owners[_address] = false;
282         OwnerRemoved(_address);
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(owners[msg.sender]);
290         _;
291     }
292 
293     /**
294      * @dev Adds minter role to address (able to create new tokens)
295      * @param _address The address that will get minter privileges
296      */
297     function addMinter(address _address) onlyOwner public {
298         minters[_address] = true;
299         MinterAdded(_address);
300     }
301 
302     /**
303      * @dev Removes minter role from address
304      * @param _address The address to remove minter privileges
305      */
306     function delMinter(address _address) onlyOwner public {
307         minters[_address] = false;
308         MinterRemoved(_address);
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the minter.
313      */
314     modifier onlyMinter() {
315         require(minters[msg.sender]);
316         _;
317     }
318 }
319 
320 /**
321  * @title NodeCrowdsale
322  * @dev NodeCrowdsale is a contract for managing a token crowdsale for NodePower project.
323  * Crowdsale have 6 phases with start and end timestamps, where investors can make
324  * token purchases and the crowdsale will assign them tokens based
325  * on a token per ETH rate and bonuses. Collected funds are forwarded to a wallet
326  * as they arrive.
327  */
328 contract NodeCrowdsale {
329     using SafeMath for uint256;
330 
331     // The token being sold
332     NodeToken public token;
333 
334     // External wallet where funds get forwarded
335     address public wallet;
336 
337     // Crowdsale administrators
338     mapping (address => bool) public owners;
339 
340     // External bots updating rates
341     mapping (address => bool) public bots;
342 
343     // USD cents per ETH exchange rate
344     uint256 public rateUSDcETH;
345 
346     // Phases list, see schedule in constructor
347     mapping (uint => Phase) phases;
348 
349     // The total number of phases (0...5)
350     uint public totalPhases = 6;
351 
352     // Description for each phase
353     struct Phase {
354         uint256 startTime;
355         uint256 endTime;
356         uint256 bonusPercent;
357     }
358 
359     // Minimum Deposit in USD cents
360     uint256 public constant minContributionUSDc = 1000;
361 
362 
363     // Amount of raised Ethers (in wei).
364     uint256 public weiRaised;
365 
366     /**
367      * event for token purchase logging
368      * @param purchaser who paid for the tokens
369      * @param beneficiary who got the tokens
370      * @param value weis paid for purchase
371      * @param bonusPercent free tokens percantage for the phase
372      * @param amount amount of tokens purchased
373      */
374     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 bonusPercent, uint256 amount);
375 
376     // event for rate update logging
377     event RateUpdate(uint256 rate);
378 
379     // event for wallet update
380     event WalletSet(address indexed wallet);
381 
382     // owners management events
383     event OwnerAdded(address indexed newOwner);
384     event OwnerRemoved(address indexed removedOwner);
385 
386     // bot management events
387     event BotAdded(address indexed newBot);
388     event BotRemoved(address indexed removedBot);
389 
390     function NodeCrowdsale(address _tokenAddress, uint256 _initialRate) public {
391         require(_tokenAddress != address(0));
392         token = NodeToken(_tokenAddress);
393         rateUSDcETH = _initialRate;
394         wallet = msg.sender;
395         owners[msg.sender] = true;
396         bots[msg.sender] = true;
397         /*
398         ICO SCHEDULE
399         Bonus        start time               end time
400         45%     2017-12-31 23:59:59 1514764799 2018-01-31 23:59:59 1517443199
401         40%     2018-02-01 00:00:00 1517443200 2018-02-14 23:59:59 1518652799
402         30%     2018-02-15 00:00:00 1518652800 2018-02-24 23:59:59 1519516799
403         20%     2018-02-25 00:00:00 1519516800 2018-03-06 23:59:59 1520380799
404         15%     2018-03-07 00:00:00 1520380800 2018-03-16 23:59:59 1521244799
405         10%     2018-03-17 00:00:00 1521244800 2018-03-26 23:59:59 1522108799
406         00%     2018-03-27 00:00:00 1522108800 -
407         */
408         phases[0].bonusPercent = 45;
409         phases[0].startTime = 1514764799;
410         phases[0].endTime = 1517443199;
411         phases[1].bonusPercent = 40;
412         phases[1].startTime = 1517443200;
413         phases[1].endTime = 1518652799;
414         phases[2].bonusPercent = 30;
415         phases[2].startTime = 1518652800;
416         phases[2].endTime = 1519516799;
417         phases[3].bonusPercent = 20;
418         phases[3].startTime = 1519516800;
419         phases[3].endTime = 1520380799;
420         phases[4].bonusPercent = 15;
421         phases[4].startTime = 1520380800;
422         phases[4].endTime = 1521244799;
423         phases[5].bonusPercent = 10;
424         phases[5].startTime = 1521244800;
425         phases[5].endTime = 1522108799;
426     }
427 
428     /**
429      * @dev Update collecting wallet address
430      * @param _address The address to send collected funds
431      */
432     function setWallet(address _address) onlyOwner public {
433         wallet = _address;
434         WalletSet(_address);
435     }
436 
437 
438     // fallback function can be used to buy tokens
439     function () external payable {
440         buyTokens(msg.sender);
441     }
442 
443     // low level token purchase function
444     function buyTokens(address beneficiary) public payable {
445         require(beneficiary != address(0));
446         require(msg.value != 0);
447 
448         uint256 currentBonusPercent = getBonusPercent(now);
449 
450         uint256 weiAmount = msg.value;
451 
452         require(calculateUSDcValue(weiAmount) >= minContributionUSDc);
453 
454         // calculate token amount to be created
455         uint256 tokens = calculateTokenAmount(weiAmount, currentBonusPercent);
456 
457         // update state
458         weiRaised = weiRaised.add(weiAmount);
459 
460         token.mint(beneficiary, tokens);
461         TokenPurchase(msg.sender, beneficiary, weiAmount, currentBonusPercent, tokens);
462 
463         forwardFunds();
464     }
465 
466     // If phase exists return corresponding bonus for the given date
467     // else return 0 (percent)
468     function getBonusPercent(uint256 datetime) public view returns (uint256) {
469         for (uint i = 0; i < totalPhases; i++) {
470             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
471                 return phases[i].bonusPercent;
472             }
473         }
474         return 0;
475     }
476 
477     // set rate
478     function setRate(uint256 _rateUSDcETH) public onlyBot {
479         // don't allow to change rate more than 10%
480         assert(_rateUSDcETH < rateUSDcETH.mul(110).div(100));
481         assert(_rateUSDcETH > rateUSDcETH.mul(90).div(100));
482         rateUSDcETH = _rateUSDcETH;
483         RateUpdate(rateUSDcETH);
484     }
485 
486     /**
487      * @dev Adds administrative role to address
488      * @param _address The address that will get administrative privileges
489      */
490     function addOwner(address _address) onlyOwner public {
491         owners[_address] = true;
492         OwnerAdded(_address);
493     }
494 
495     /**
496      * @dev Removes administrative role from address
497      * @param _address The address to remove administrative privileges from
498      */
499     function delOwner(address _address) onlyOwner public {
500         owners[_address] = false;
501         OwnerRemoved(_address);
502     }
503 
504     /**
505      * @dev Throws if called by any account other than the owner.
506      */
507     modifier onlyOwner() {
508         require(owners[msg.sender]);
509         _;
510     }
511 
512     /**
513      * @dev Adds rate updating bot
514      * @param _address The address of the rate bot
515      */
516     function addBot(address _address) onlyOwner public {
517         bots[_address] = true;
518         BotAdded(_address);
519     }
520 
521     /**
522      * @dev Removes rate updating bot address
523      * @param _address The address of the rate bot
524      */
525     function delBot(address _address) onlyOwner public {
526         bots[_address] = false;
527         BotRemoved(_address);
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the bot.
532      */
533     modifier onlyBot() {
534         require(bots[msg.sender]);
535         _;
536     }
537 
538     // calculate deposit value in USD Cents
539     function calculateUSDcValue(uint256 _weiDeposit) public view returns (uint256) {
540 
541         // wei per USD cent
542         uint256 weiPerUSDc = 1 ether/rateUSDcETH;
543 
544         // Deposited value converted to USD cents
545         uint256 depositValueInUSDc = _weiDeposit.div(weiPerUSDc);
546         return depositValueInUSDc;
547     }
548 
549     // calculates how much tokens will beneficiary get
550     // for given amount of wei
551     function calculateTokenAmount(uint256 _weiDeposit, uint256 _bonusTokensPercent) public view returns (uint256) {
552         uint256 mainTokens = calculateUSDcValue(_weiDeposit);
553         uint256 bonusTokens = mainTokens.mul(_bonusTokensPercent).div(100);
554         return mainTokens.add(bonusTokens);
555     }
556 
557     // send ether to the fund collection wallet
558     // override to create custom fund forwarding mechanisms
559     function forwardFunds() internal {
560         wallet.transfer(msg.value);
561     }
562 
563 
564 
565 }