1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of. 
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 contract MigrationAgent {
189     function migrateFrom(address _from, uint256 _value);
190 }
191 
192 /**
193     BlockChain Board Of Derivatives Token.
194  */
195 contract BBDToken is StandardToken, Ownable {
196 
197     // Metadata
198     string public constant name = "BlockChain Board Of Derivatives Token";
199     string public constant symbol = "BBD";
200     uint256 public constant decimals = 18;
201     string private constant version = '1.0.0';
202 
203     // Crowdsale parameters
204     uint256 public constant startTime = 1506844800; //Sunday, 1 October 2017 08:00:00 GMT
205     uint256 public constant endTime = 1509523200;  // Wednesday, 1 November 2017 08:00:00 GMT
206 
207     uint256 public constant creationMaxCap = 300000000 * 10 ** decimals;
208     uint256 public constant creationMinCap = 2500000 * 10 ** decimals;
209 
210     uint256 private constant startCreationRateOnTime = 1666; // 1666 BDD per 1 ETH
211     uint256 private constant endCreationRateOnTime = 1000; // 1000 BDD per 1 ETH
212 
213     uint256 private constant quantityThreshold_10 = 10 ether;
214     uint256 private constant quantityThreshold_30 = 30 ether;
215     uint256 private constant quantityThreshold_100 = 100 ether;
216     uint256 private constant quantityThreshold_300 = 300 ether;
217 
218     uint256 private constant quantityBonus_10 = 500;    // 5%
219     uint256 private constant quantityBonus_30 = 1000;  // 10%
220     uint256 private constant quantityBonus_100 = 1500; // 15%
221     uint256 private constant quantityBonus_300 = 2000; // 20%
222 
223     // The flag indicates if the crowdsale was finalized
224     bool public finalized = false;
225 
226     // Migration information
227     address public migrationAgent;
228     uint256 public totalMigrated;
229 
230     // Exchange address
231     address public exchangeAddress;
232 
233     // Team accounts
234     address private constant mainAccount = 0xEB1D40f6DA0E77E2cA046325F6F2a76081B4c7f4;
235     address private constant coreTeamMemberOne = 0xe43088E823eA7422D77E32a195267aE9779A8B07;
236     address private constant coreTeamMemberTwo = 0xad00884d1E7D0354d16fa8Ab083208c2cC3Ed515;
237 
238     // Ether raised
239     uint256 private raised = 0;
240 
241     // Since we have different exchange rates, we need to keep track of how
242     // much ether each contributed in case that we need to issue a refund
243     mapping (address => uint256) private ethBalances;
244 
245     uint256 private constant divisor = 10000;
246 
247     // Events
248     event LogRefund(address indexed _from, uint256 _value);
249     event LogMigrate(address indexed _from, address indexed _to, uint256 _value);
250     event LogBuy(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
251 
252     // Check if min cap was archived.
253     modifier onlyWhenICOReachedCreationMinCap() {
254         require( totalSupply >= creationMinCap );
255         _;
256     }
257 
258     function() payable {
259         buy(msg.sender);
260     }
261 
262     function creationRateOnTime() public constant returns (uint256) {
263         uint256 currentPrice;
264 
265         if (now > endTime) {
266             currentPrice = endCreationRateOnTime;
267         }
268         else {
269             //Price is changing lineral starting from  startCreationRateOnTime to endCreationRateOnTime
270             uint256 rateRange = startCreationRateOnTime - endCreationRateOnTime;
271             uint256 timeRange = endTime - startTime;
272             currentPrice = startCreationRateOnTime.sub(rateRange.mul(now.sub(startTime)).div(timeRange));
273         }
274 
275         return currentPrice;
276     }
277 
278     //Calculate number of BBD tokens for provided ether
279     function calculateBDD(uint256 _ethVal) private constant returns (uint256) {
280         uint256 bonus;
281 
282         //We provide bonus depending on eth value
283         if (_ethVal < quantityThreshold_10) {
284             bonus = 0; // 0% bonus
285         }
286         else if (_ethVal < quantityThreshold_30) {
287             bonus = quantityBonus_10; // 5% bonus
288         }
289         else if (_ethVal < quantityThreshold_100) {
290             bonus = quantityBonus_30; // 10% bonus
291         }
292         else if (_ethVal < quantityThreshold_300) {
293             bonus = quantityBonus_100; // 15% bonus
294         }
295         else {
296             bonus = quantityBonus_300; // 20% bonus
297         }
298 
299         // Get number of BBD tokens
300         return _ethVal.mul(creationRateOnTime()).mul(divisor.add(bonus)).div(divisor);
301     }
302 
303     // Buy BBD
304     function buy(address _beneficiary) payable {
305         require(!finalized);
306         require(msg.value != 0);
307         require(now <= endTime);
308         require(now >= startTime);
309 
310         uint256 bbdTokens = calculateBDD(msg.value);
311         uint256 additionalBBDTokensForMainAccount = bbdTokens.mul(2250).div(divisor); // 22.5%
312         uint256 additionalBBDTokensForCoreTeamMember = bbdTokens.mul(125).div(divisor); // 1.25%
313 
314         //Increase by 25% number of bbd tokens on each buy.
315         uint256 checkedSupply = totalSupply.add(bbdTokens)
316                                            .add(additionalBBDTokensForMainAccount)
317                                            .add(2 * additionalBBDTokensForCoreTeamMember);
318 
319         require(creationMaxCap >= checkedSupply);
320 
321         totalSupply = checkedSupply;
322 
323         //Update balances
324         balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);
325         balances[mainAccount] = balances[mainAccount].add(additionalBBDTokensForMainAccount);
326         balances[coreTeamMemberOne] = balances[coreTeamMemberOne].add(additionalBBDTokensForCoreTeamMember);
327         balances[coreTeamMemberTwo] = balances[coreTeamMemberTwo].add(additionalBBDTokensForCoreTeamMember);
328 
329         ethBalances[_beneficiary] = ethBalances[_beneficiary].add(msg.value);
330 
331         raised += msg.value;
332 
333         if (exchangeAddress != 0x0 && totalSupply >= creationMinCap && msg.value >= 1 ether) {
334             // After archiving min cap we start moving 10% to exchange. It will help with liquidity on exchange.
335             exchangeAddress.transfer(msg.value.mul(1000).div(divisor)); // 10%
336         }
337 
338         LogBuy(msg.sender, _beneficiary, msg.value, bbdTokens);
339     }
340 
341     // Finalize for successful ICO
342     function finalize() onlyOwner external {
343         require(!finalized);
344         require(now >= endTime || totalSupply >= creationMaxCap);
345 
346         finalized = true;
347 
348         uint256 ethForCoreMember = raised.mul(500).div(divisor);
349 
350         coreTeamMemberOne.transfer(ethForCoreMember); // 5%
351         coreTeamMemberTwo.transfer(ethForCoreMember); // 5%
352         mainAccount.transfer(this.balance); //90%
353     }
354 
355     // Refund if ICO won't reach min cap
356     function refund() external {
357         require(now > endTime);
358         require(totalSupply < creationMinCap);
359 
360         uint256 bddVal = balances[msg.sender];
361         require(bddVal > 0);
362         uint256 ethVal = ethBalances[msg.sender];
363         require(ethVal > 0);
364 
365         balances[msg.sender] = 0;
366         ethBalances[msg.sender] = 0;
367         totalSupply = totalSupply.sub(bddVal);
368 
369         msg.sender.transfer(ethVal);
370 
371         LogRefund(msg.sender, ethVal);
372     }
373 
374     // Allow to migrate to next version of contract
375     function migrate(uint256 _value) external {
376         require(finalized);
377         require(migrationAgent != 0x0);
378         require(_value > 0);
379         require(_value <= balances[msg.sender]);
380 
381         balances[msg.sender] = balances[msg.sender].sub(_value);
382         totalSupply = totalSupply.sub(_value);
383         totalMigrated = totalMigrated.add(_value);
384 
385         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
386 
387         LogMigrate(msg.sender, migrationAgent, _value);
388     }
389 
390     // Set migration Agent
391     function setMigrationAgent(address _agent) onlyOwner external {
392         require(finalized);
393         require(migrationAgent == 0x0);
394 
395         migrationAgent = _agent;
396     }
397 
398     // Set exchange address
399     function setExchangeAddress(address _exchangeAddress) onlyOwner external {
400         require(exchangeAddress == 0x0);
401 
402         exchangeAddress = _exchangeAddress;
403     }
404 
405     function transfer(address _to, uint _value) onlyWhenICOReachedCreationMinCap returns (bool) {
406         return super.transfer(_to, _value);
407     }
408 
409     function transferFrom(address _from, address _to, uint _value) onlyWhenICOReachedCreationMinCap returns (bool) {
410         return super.transferFrom(_from, _to, _value);
411     }
412 
413     // Transfer BBD to exchange.
414     function transferToExchange(address _from, uint256 _value) onlyWhenICOReachedCreationMinCap returns (bool) {
415         require(msg.sender == exchangeAddress);
416 
417         balances[exchangeAddress] = balances[exchangeAddress].add(_value);
418         balances[_from] = balances[_from].sub(_value);
419 
420         Transfer(_from, exchangeAddress, _value);
421 
422         return true;
423     }
424 
425     // ICO overview
426     function icoOverview() constant returns (uint256 currentlyRaised, uint256 currentlyTotalSupply, uint256 currentlyCreationRateOnTime){
427         currentlyRaised = raised;
428         currentlyTotalSupply = totalSupply;
429         currentlyCreationRateOnTime = creationRateOnTime();
430     }
431 }