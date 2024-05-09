1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10     address public owner;
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     function Ownable()public {
17         owner = msg.sender;
18     }
19     
20     /**
21     * @dev Throws if called by any account other than the owner.
22     */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27     
28     /**
29     * @dev Allows the current owner to transfer control of the contract to a newOwner.
30     * @param newOwner The address to transfer ownership to.
31     */
32     function transferOwnership(address newOwner)public onlyOwner {
33         require(newOwner != address(0));      
34         owner = newOwner;
35     }
36 }
37 
38 /**
39 * @title ERC20Basic
40 * @dev Simpler version of ERC20 interface
41 * @dev https://github.com/ethereum/EIPs/issues/179
42 */
43 contract ERC20Basic is Ownable {
44     uint256 public totalSupply;
45     function balanceOf(address who) public constant returns (uint256);
46     function transfer(address to, uint256 value)public returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51 * @title ERC20 interface
52 * @dev https://github.com/ethereum/EIPs/issues/20
53 */
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender)public constant returns (uint256);
56     function transferFrom(address from, address to, uint256 value)public returns(bool);
57     function approve(address spender, uint256 value)public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62 * @title SafeMath
63 * @dev Math operations with safety checks that throw on error
64 */
65 library SafeMath {
66     
67     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
68         uint256 c = a * b;
69         assert(a == 0 || c / a == b);
70         return c;
71     }
72     
73     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79     
80     function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84     
85     function add(uint256 a, uint256 b) internal pure  returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances. 
95  */
96 contract BasicToken is ERC20Basic {
97     
98     using SafeMath for uint256;
99     
100     bool freeze = false;
101     
102     mapping(address => uint256) balances;
103     
104     uint endOfICO = 1527681600; // 05.30.2018 12:00
105     
106     /**
107     * @dev Sets the date of the ICO end.
108     * @param ICO_end The date of the ICO end.
109     */
110     function setEndOfICO(uint ICO_end) public onlyOwner {
111         endOfICO = ICO_end;
112     }
113     
114     /**
115     * @dev Throws if called before the end of ICO.
116     */
117     modifier restrictionOnUse() {
118         require(now > endOfICO);
119         _;
120     }
121     
122     /**
123     * @dev Transfers tokens to a specified address.
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public restrictionOnUse isNotFrozen returns (bool) {
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         Transfer(msg.sender, _to, _value);
131         return true;
132     }
133     
134     /**
135     * @dev Changes the value of freeze variable.
136     */
137     function freezeToken()public onlyOwner {
138         freeze = !freeze;
139     }
140     
141     /**
142     * @dev Throws if called when contract is frozen.
143     */
144     modifier isNotFrozen(){
145         require(!freeze);
146         _;
147     }
148     
149     /**
150     * @dev Gets the balance of the specified address.
151     * @param _owner The address to query the balance of.
152     */
153     function balanceOf(address _owner)public constant returns (uint256 balance) {
154         return balances[_owner];
155     }
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166     mapping (address => mapping (address => uint256)) allowed;
167     
168     /**
169     * @dev Transfers tokens from one address to another.
170     * @param _from The address which you want to send tokens from.
171     * @param _to The address which you want to transfer to.
172     * @param _value The amount of tokens to be transfered.
173     */
174     function transferFrom(address _from, address _to, uint256 _value) public restrictionOnUse isNotFrozen returns(bool) {
175         require(_value <= allowed[_from][msg.sender]);
176         var _allowance = allowed[_from][msg.sender];
177         balances[_to] = balances[_to].add(_value);
178         balances[_from] = balances[_from].sub(_value);
179         allowed[_from][msg.sender] = _allowance.sub(_value);
180         Transfer(_from, _to, _value);
181         return true;
182     }
183     
184     /**
185     * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
186     * @param _spender The address which will spend the funds.
187     * @param _value The amount of tokens to be spent.
188     */
189     function approve(address _spender, uint256 _value) public restrictionOnUse isNotFrozen returns (bool) {
190         require((_value > 0)&&(_value <= balances[msg.sender]));
191         allowed[msg.sender][_spender] = _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     /**
197     * @dev Function to check the amount of tokens that an owner allowed to a spender.
198     * @param _owner The address which owns the funds.
199     * @param _spender The address which will spend the funds.
200     */
201     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 }
205 
206 /**
207  * @title Mintable token
208  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
209  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
210  */
211 contract MintableToken is StandardToken {
212     
213     event Mint(address indexed to, uint256 amount);
214     
215     event MintFinished();
216 
217     bool public mintingFinished = false;
218     
219     /**
220     * @dev Throws if called when minting is finished.
221     */
222     modifier canMint() {
223         require(!mintingFinished);
224         _;
225     }
226     
227     /**
228     * @dev Function to mint tokens
229     * @param _to The address that will recieve the minted tokens.
230     * @param _amount The amount of tokens to mint.
231     */
232     function mint(address _to, uint256 _amount) internal canMint returns (bool) {
233         totalSupply = totalSupply.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         Mint(_to, _amount);
236         return true;
237     }
238     
239     /**
240     * @dev Function to stop minting new tokens.
241     */
242     function finishMinting() public onlyOwner returns (bool) {
243         mintingFinished = !mintingFinished;
244         MintFinished();
245         return true;
246     }
247 }
248 
249 /**
250  * @title Burnable Token
251  * @dev Token that can be irreversibly burned (destroyed).
252  */
253 contract BurnableToken is MintableToken {
254     
255     using SafeMath for uint;
256     
257     /**
258     * @dev Burns a specific amount of tokens.
259     * @param _value The amount of token to be burned.
260     */
261     function burn(uint _value) restrictionOnUse isNotFrozen public returns (bool success) {
262         require((_value > 0) && (_value <= balances[msg.sender]));
263         balances[msg.sender] = balances[msg.sender].sub(_value);
264         totalSupply = totalSupply.sub(_value);
265         Burn(msg.sender, _value);
266         return true;
267     }
268  
269     /**
270     * @dev Burns a specific amount of tokens from another address.
271     * @param _value The amount of tokens to be burned.
272     * @param _from The address which you want to burn tokens from.
273     */
274     function burnFrom(address _from, uint _value) restrictionOnUse isNotFrozen public returns (bool success) {
275         require((balances[_from] > _value) && (_value <= allowed[_from][msg.sender]));
276         var _allowance = allowed[_from][msg.sender];
277         balances[_from] = balances[_from].sub(_value);
278         totalSupply = totalSupply.sub(_value);
279         allowed[_from][msg.sender] = _allowance.sub(_value);
280         Burn(_from, _value);
281         return true;
282     }
283 
284     event Burn(address indexed burner, uint indexed value);
285 }
286 
287 /**
288  * @title SimpleTokenCoin
289  * @dev SimpleToken is a standard ERC20 token with some additional functionality
290  */
291 contract SimpleTokenCoin is BurnableToken {
292     
293     address public forBounty = 0xdd5Aea206449d610A9e0c45B6b3fdAc684e0c8bD;
294     address public forTeamCOT = 0x3FFeEcc08Dc94Fd5089A8C377a6e7Bf15F0D2f8d;
295     address public forTeamETH = 0x619E27C6BfEbc196BA048Fb79B397314cfA82d89;
296     address public forFund = 0x7b7c6d8ce28923e39611dD14A68DA6Af63c63FF7;
297     address public forLoyalty = 0x22152A186AaD84b0eaadAD00e3F19547C30CcB02;
298     
299     string public constant name = "CoinTour";
300     
301     string public constant symbol = "COT";
302     
303     uint32 public constant decimals = 8;
304     
305     address private contractAddress;
306     
307     /**
308     * @dev Sets the address of approveAndCall contract.
309     * @param _address The address of approveAndCall contract.
310     */
311     function setContractAddress (address _address) public onlyOwner {
312         contractAddress = _address;
313     }
314     
315     /**
316     * @dev The SimpleTokenCoin constructor mints tokens to four addresses.
317     */
318     function SimpleTokenCoin()public {
319         mint(forBounty, 4000000 * 10**8);
320         mint(forTeamCOT, 10000000 * 10**8); 
321         mint(forFund, 10000000 * 10**8);
322         mint(forLoyalty, 2000000 * 10**8);
323     }
324     
325     /**
326     * @dev Function to send ETH from contract address to team ETH address.
327     */
328     function sendETHfromContract() public onlyOwner {
329         forTeamETH.transfer(this.balance);
330     }
331     
332     /**
333      * @dev Sends to multiple addresses using two arrays which
334      * include the address and the amount of tokens.
335      * @param users Array of addresses to send to.
336      * @param bonus Array of amount of tokens to send.
337      */
338     function multisend(address[] users, uint[] bonus) public {
339         for (uint i = 0; i < users.length; i++) {
340             transfer(users[i], bonus[i]);
341         }
342     }
343     
344     /**
345      * @dev Token owner can approve for spender to execute another function.
346      * @param tokens Amount of tokens to execute function.
347      * @param data Additional data.
348      */
349     function approveAndCall(uint tokens, bytes data) public restrictionOnUse returns (bool success) {
350         approve(contractAddress, tokens);
351         ApproveAndCallFallBack(contractAddress).receiveApproval(msg.sender, tokens, data);
352         return true;
353     }
354 }
355 
356 interface ApproveAndCallFallBack { function receiveApproval(address from, uint256 tokens, bytes data) external; }
357 
358 /**
359  * @title Crowdsale 
360  * @dev Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
361  */
362 contract Crowdsale is SimpleTokenCoin {
363     
364     using SafeMath for uint;
365     
366     uint public startPreICO;
367     
368     uint public startICO;
369     
370     uint public periodPreICO;
371     
372     uint public firstPeriodOfICO;
373     
374     uint public secondPeriodOfICO;
375     
376     uint public thirdPeriodOfICO;
377 
378     uint public hardcap;
379 
380     uint public rate;
381     
382     uint public softcap;
383     
384     uint public maxTokensAmount;
385     
386     uint public availableTokensAmount;
387     
388     mapping(address => uint) ethBalance;
389     
390     /**
391     * @dev Data type to save bonus system's information.
392     */
393     struct BonusSystem {
394         //Period number
395         uint period;
396         // UNIX timestamp of period start
397         uint start;
398         // UNIX timestamp of period finish
399         uint end;
400         //Amount of tokens available per period
401         uint tokensPerPeriod;
402         //Sold tokens Amount
403         uint soldTokens;
404         // How many % tokens will add
405         uint bonus;
406     }
407     
408     BonusSystem[] public bonus;
409     
410     /**
411     * @dev Function to change bonus system.
412     * @param percentageOfTokens Percentage of tokens for each period.
413     * @param bonuses Percentage of bonus for each period.
414     */
415     function changeBonusSystem(uint[] percentageOfTokens, uint[] bonuses) public onlyOwner{
416         for (uint i = 0; i < bonus.length; i++) {
417             bonus[i].tokensPerPeriod = availableTokensAmount / 100 * percentageOfTokens[i];
418             bonus[i].bonus = bonuses[i];
419         }
420     }
421     
422     /**
423     * @dev Function to set bonus system.
424     * @param preICOtokens , firstPeriodTokens, secondPeriodTokens, thirdPeriodTokens Percentage of tokens for each period.
425     * @param preICObonus , firstPeriodBonus, secondPeriodBonus, thirdPeriodBonus Percentage of bonus for each period.
426     */
427     function setBonusSystem(uint preICOtokens, uint preICObonus, uint firstPeriodTokens, uint firstPeriodBonus, 
428                             uint secondPeriodTokens, uint secondPeriodBonus, uint thirdPeriodTokens, uint thirdPeriodBonus) private {
429         bonus.push(BonusSystem(0, startPreICO, startPreICO + periodPreICO * 1 days, availableTokensAmount / 100 * preICOtokens, 0, preICObonus));
430         bonus.push(BonusSystem(1, startICO, startICO + firstPeriodOfICO * 1 days, availableTokensAmount / 100 * firstPeriodTokens, 0, firstPeriodBonus));
431         bonus.push(BonusSystem(2, startICO + firstPeriodOfICO * 1 days, startICO + (firstPeriodOfICO + secondPeriodOfICO) * 1 days, availableTokensAmount / 100 * secondPeriodTokens, 0, secondPeriodBonus));
432         bonus.push(BonusSystem(3, startICO + (firstPeriodOfICO + secondPeriodOfICO) * 1 days, startICO + (firstPeriodOfICO + secondPeriodOfICO + thirdPeriodOfICO) * 1 days, availableTokensAmount / 100 * thirdPeriodTokens, 0, thirdPeriodBonus));
433     }
434     
435     /**
436     * @dev Gets current bonus system.
437     */
438     function getCurrentBonusSystem() public constant returns (BonusSystem) {
439       for (uint i = 0; i < bonus.length; i++) {
440         if (bonus[i].start <= now && bonus[i].end >= now) {
441           return bonus[i];
442         }
443       }
444     }
445 
446     /**
447     * @dev Sets values of periods.
448     * @param PreICO_start The value of pre ICO start.
449     * @param PreICO_period The duration of pre ICO period.
450     * @param ICO_firstPeriod , ICO_secondPeriod, ICO_thirdPeriod The duration of each period.
451     */
452     function setPeriods(uint PreICO_start, uint PreICO_period, uint ICO_start, uint ICO_firstPeriod, uint ICO_secondPeriod, uint ICO_thirdPeriod) public onlyOwner {
453         startPreICO = PreICO_start;
454         periodPreICO = PreICO_period;
455         startICO = ICO_start;
456         firstPeriodOfICO = ICO_firstPeriod;
457         secondPeriodOfICO = ICO_secondPeriod;
458         thirdPeriodOfICO = ICO_thirdPeriod;
459         bonus[0].start = PreICO_start;
460         bonus[0].end = PreICO_start + PreICO_period * 1 days;
461         bonus[1].start = ICO_start;
462         bonus[1].end = ICO_start + ICO_firstPeriod * 1 days;
463         bonus[2].start = bonus[1].end;
464         bonus[2].end = bonus[2].start + ICO_secondPeriod * 1 days;
465         bonus[3].start = bonus[2].end;
466         bonus[3].end = bonus[2].end + ICO_thirdPeriod * 1 days;
467     }
468     
469     /**
470     * @dev Sets the rate of COT.
471     */
472     function setRate (uint _rate) public onlyOwner {
473         rate = _rate * 10**8 ;
474     }
475     
476     /**
477     * @dev The Crowdsale constructor sets the first values to variables.
478     */
479     function Crowdsale() public{
480         rate = 16000 * 10**8 ;
481         startPreICO = 1522065600; // 03.26.2018 12:00
482         periodPreICO = 14;
483         startICO = 1525089600; // 04.30.2018 12:00
484         firstPeriodOfICO = secondPeriodOfICO = thirdPeriodOfICO = 10;
485         hardcap = 59694 * 10**17;
486         softcap = 400 * 10**18;
487         maxTokensAmount = 100000000 * 10**8;
488         availableTokensAmount = maxTokensAmount - totalSupply;
489         setBonusSystem(20, 40, 25, 25, 25, 15, 30, 0);
490     }
491     
492     /**
493     * @dev Throws if called when the period or tokens are over.
494     */
495     modifier isUnderPeriodLimit() {
496         require(getCurrentBonusSystem().start <= now && getCurrentBonusSystem().end >= now && getCurrentBonusSystem().tokensPerPeriod - getCurrentBonusSystem().soldTokens > 0);
497         _;
498     }
499 
500     /**
501     * @dev Function to mint tokens.
502     * @param _to The address that will recieve the minted tokens.
503     * @param _amount The amount of tokens to mint.
504     */
505     function buyTokens(address _to, uint256 _amount) internal canMint isNotFrozen returns (bool) {
506         totalSupply = totalSupply.add(_amount);
507         bonus[getCurrentBonusSystem().period].soldTokens = getCurrentBonusSystem().soldTokens.add(_amount);
508         balances[_to] = balances[_to].add(_amount);
509         Mint(_to, _amount);
510         return true;
511     }
512     
513     /**
514     * @dev Refund 'msg.sender' in the case the Token Sale didn't 
515     * reach the minimum funding goal.
516     */
517     function refund() restrictionOnUse isNotFrozen public {
518         require(this.balance < softcap);
519         uint value = ethBalance[msg.sender]; 
520         ethBalance[msg.sender] = 0; 
521         msg.sender.transfer(value); 
522     }
523     
524     /**
525     * @dev Сalculates the required amount of tokens to be minted. 
526     */
527     function createTokens()private isUnderPeriodLimit isNotFrozen {
528         uint tokens = rate.mul(msg.value).div(1 ether);
529         uint bonusTokens = tokens / 100 * getCurrentBonusSystem().bonus;
530         tokens += bonusTokens;
531         if (msg.value < 10 finney || (tokens > getCurrentBonusSystem().tokensPerPeriod.sub(getCurrentBonusSystem().soldTokens))) {
532             msg.sender.transfer(msg.value);
533         }
534         else {
535             forTeamETH.transfer(msg.value);
536             buyTokens(msg.sender, tokens);
537             ethBalance[msg.sender] = ethBalance[msg.sender].add(msg.value);
538         }
539     }
540     
541     /**
542     * Called when ETH comes to the contract.
543     */
544     function() external payable {
545         createTokens();
546     }
547 }