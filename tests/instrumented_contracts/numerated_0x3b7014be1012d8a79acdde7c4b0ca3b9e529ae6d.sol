1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic, Ownable {
116   using SafeMath for uint256;
117   mapping(address => uint256) balances;
118 
119   uint256 totalSupply_;
120 
121   /**
122   * @dev total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 /**
249  * @title Mintable token
250  * @dev Simple ERC20 Token example, with mintable token creation
251  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
252  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
253  */
254 contract MintableToken is StandardToken {
255   event Mint(address indexed to, uint256 amount);
256   event MintFinished();
257 
258   bool public mintingFinished = false;
259 
260 
261   modifier canMint() {
262     require(!mintingFinished);
263     _;
264   }
265 
266   /**
267    * @dev Function to mint tokens
268    * @param _to The address that will receive the minted tokens.
269    * @param _amount The amount of tokens to mint.
270    * @return A boolean that indicates if the operation was successful.
271    */
272   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
273     totalSupply_ = totalSupply_.add(_amount);
274     balances[_to] = balances[_to].add(_amount);
275     emit Mint(_to, _amount);
276     emit Transfer(address(0), _to, _amount);
277     return true;
278   }
279 
280   /**
281    * @dev Function to stop minting new tokens.
282    * @return True if the operation was successful.
283    */
284   function finishMinting() onlyOwner canMint public returns (bool) {
285     mintingFinished = true;
286     emit MintFinished();
287     return true;
288   }
289 }
290 
291 
292 contract LTE is Ownable, MintableToken {
293   using SafeMath for uint256;    
294   string public constant name = "LTE";
295   string public constant symbol = "LTE";
296   uint32 public constant decimals = 18;
297   address public addressBounty;
298   address public addressTeam;
299   address public addressAdvisors;
300   address public addressDividendReserve;
301   address public addressPrivateSale;
302   uint256 public summBounty;
303   uint256 public summTeam;
304   uint256 public summAdvisors;
305   uint256 public summDividendReserve;
306   uint256 public summPrivateSale;
307 
308   function LTE() public {
309     addressBounty = 0x55a56c4666b95003f21f6273D17A449405b7CBaa; 
310     addressTeam = 0x4847a781F2FfE63f3474ba694FA96D63D5653D23; 
311     addressAdvisors = 0xc7a4784e57cf7d545F39C624c29147bC528b5128; 
312     addressDividendReserve = 0x9FAc8dDD09f8e12f3fA006b46dE7D52288DAA6c6; 
313     addressPrivateSale = 0xD9AB546F703a28360fc5653d5b6f5af3fb70586F; 
314     // Token distribution
315     summBounty = 890677 * (10 ** uint256(decimals));
316     summTeam = 11133474 * (10 ** uint256(decimals));
317     summAdvisors = 2226694 * (10 ** uint256(decimals));
318     summDividendReserve = 22266949 * (10 ** uint256(decimals));
319     summPrivateSale = 8000000 * (10 ** uint256(decimals));
320     // Founders and supporters initial Allocations
321     mint(addressBounty, summBounty);
322     mint(addressTeam, summTeam);
323     mint(addressAdvisors, summAdvisors);
324     mint(addressDividendReserve, summDividendReserve);
325     mint(addressPrivateSale, summPrivateSale);
326   }
327 }
328 
329 /**
330  * @title Crowdsale
331  * @dev Crowdsale is a base contract for managing a token crowdsale.
332  * Crowdsales have a start and end timestamps, where Contributors can make
333  * token Contributions and the crowdsale will assign them tokens based
334  * on a token per ETH rate. Funds collected are forwarded to a wallet
335  * as they arrive. The contract requires a MintableToken that will be
336  * minted as contributions arrive, note that the crowdsale contract
337  * must be owner of the token in order to be able to mint it.
338  */
339 contract Crowdsale is Ownable {
340   using SafeMath for uint256;
341   LTE public token;
342   
343   // start and end timestamps where investments are allowed (both inclusive)
344   uint256 public   startPreICOStage1;
345   uint256 public   endPreICOStage1;
346   uint256 public   startPreICOStage2;
347   uint256 public   endPreICOStage2;  
348   uint256 public   startPreICOStage3;
349   uint256 public   endPreICOStage3;   
350   uint256 public   startICOStage1;
351   uint256 public   endICOStage1;
352   uint256 public   startICOStage2;
353   uint256 public   endICOStage2; 
354   
355   //token distribution
356   // uint256 public maxIco;
357   uint256 public  sumPreICO1;
358   uint256 public  sumPreICO2;
359   uint256 public  sumPreICO3;
360   uint256 public  sumICO1;
361   uint256 public  sumICO2;
362   
363   //Hard cap
364   uint256 public  sumHardCapPreICO1;
365   uint256 public  sumHardCapPreICO2;
366   uint256 public  sumHardCapPreICO3;
367   uint256 public  sumHardCapICO1;
368   uint256 public  sumHardCapICO2;
369   
370   uint256 public totalSoldTokens;
371   //uint256 public minimumContribution;
372   // how many token units a Contributor gets per wei
373   uint256 public rateIco;  
374   // address where funds are collected
375   address public wallet;
376   
377 /**
378 * event for token Procurement logging
379 * @param contributor who Pledged for the tokens
380 * @param beneficiary who got the tokens
381 * @param value weis Contributed for Procurement
382 * @param amount amount of tokens Procured
383 */
384   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
385   
386   function Crowdsale() public {
387     
388     token = createTokenContract();
389     // rate;
390     rateIco = 2286;	
391     // start and end timestamps where investments are allowed
392     //start/end for stage of ICO
393     startPreICOStage1 = 1532908800; // July      30 2018 00:00:00 +0000
394     endPreICOStage1   = 1533859200; // August    10 2018 00:00:00 +0000
395     startPreICOStage2 = 1533859200; // August    10 2018 00:00:00 +0000
396     endPreICOStage2   = 1534723200; // August    20 2018 00:00:00 +0000
397     startPreICOStage3 = 1534723200; // August    20 2018 00:00:00 +0000
398     endPreICOStage3   = 1535673600; // August    31 2018 00:00:00 +0000
399     startICOStage1    = 1535673600; // August    31 2018 00:00:00 +0000
400     endICOStage1      = 1536192000; // September 6 2018 00:00:00 +0000
401     startICOStage2    = 1536192000; // September 6 2018 00:00:00 +0000
402     endICOStage2      = 1536537600; // September 10 2018 00:00:00 +0000    
403 
404     sumHardCapPreICO1 = 3900000 * 1 ether;
405     sumHardCapPreICO2 = 5000000 * 1 ether;
406     sumHardCapPreICO3 = 5750000 * 1 ether;
407     sumHardCapICO1 = 9900000 *  1 ether;
408     sumHardCapICO2 = 20000000 * 1 ether;
409 
410     // address where funds are collected
411     wallet = 0x6e9f5B0E49A7039bD1d4bdE84e4aF53b8194287d;
412   }
413 
414   function setRateIco(uint _rateIco) public onlyOwner  {
415     rateIco = _rateIco;
416   }   
417 
418   // fallback function can be used to Procure tokens
419   function () external payable {
420     procureTokens(msg.sender);
421   }
422   
423   function createTokenContract() internal returns (LTE) {
424     return new LTE();
425   }
426 
427   function getRateIcoWithBonus() public view returns (uint256) {
428     uint256 bonus;
429     //PreICO   
430     if (now >= startPreICOStage1 && now < endPreICOStage1){
431       bonus = 30;    
432     }     
433     if (now >= startPreICOStage2 && now < endPreICOStage2){
434       bonus = 25;    
435     }        
436     if (now >= startPreICOStage3 && now < endPreICOStage3){
437       bonus = 15;    
438     }
439     if (now >= startICOStage1 && now < endICOStage1){
440       bonus = 10;    
441     }    
442     if (now >= startICOStage2 && now < endICOStage2){
443       bonus = 0;    
444     }      
445     return rateIco + rateIco.mul(bonus).div(100);
446   }  
447   
448   function checkHardCap(uint256 _value) public {
449     //PreICO   
450     if (now >= startPreICOStage1 && now < endPreICOStage1){
451       require(_value.add(sumPreICO1) <= sumHardCapPreICO1);
452       sumPreICO1 = sumPreICO1.add(_value);
453     }     
454     if (now >= startPreICOStage2 && now < endPreICOStage2){
455       require(_value.add(sumPreICO2) <= sumHardCapPreICO2);
456       sumPreICO2 = sumPreICO2.add(_value);  
457     }        
458     if (now >= startPreICOStage3 && now < endPreICOStage3){
459       require(_value.add(sumPreICO3) <= sumHardCapPreICO3);
460       sumPreICO3 = sumPreICO3.add(_value);    
461     }
462     if (now >= startICOStage1 && now < endICOStage1){
463       require(_value.add(sumICO1) <= sumHardCapICO1);
464       sumICO1 = sumICO1.add(_value);  
465     }    
466     if (now >= startICOStage2 && now < endICOStage2){
467       require(_value.add(sumICO2) <= sumHardCapICO2);
468       sumICO2 = sumICO2.add(_value);   
469     }      
470   } 
471   function procureTokens(address _beneficiary) public payable {
472     uint256 tokens;
473     uint256 weiAmount = msg.value;
474     uint256 rate;
475     address _this = this;
476     require(now >= startPreICOStage1);
477     require(now <= endICOStage2);
478     require(_beneficiary != address(0));
479     rate = getRateIcoWithBonus();
480     tokens = weiAmount.mul(rate);
481     checkHardCap(tokens);
482     //totalSoldTokens = totalSoldTokens.add(tokens);
483     wallet.transfer(_this.balance);
484     token.mint(_beneficiary, tokens);
485     emit TokenProcurement(msg.sender, _beneficiary, weiAmount, tokens);
486   }
487 }