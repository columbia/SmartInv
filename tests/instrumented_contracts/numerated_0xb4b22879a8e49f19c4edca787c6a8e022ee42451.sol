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
292 contract BVA is Ownable, MintableToken {
293   using SafeMath for uint256;    
294   string public constant name = "BlockchainValley";
295   string public constant symbol = "BVA";
296   uint32 public constant decimals = 18;
297   address public addressFounders;
298   uint256 public summFounders;
299   function BVA() public {
300     addressFounders = 0x6e69307fe1fc55B2fffF680C5080774D117f1154;  
301     summFounders = 35340000 * (10 ** uint256(decimals));  
302     mint(addressFounders, summFounders);      
303   }      
304       
305 }
306 
307 /**
308  * @title Crowdsale
309  * @dev Crowdsale is a base contract for managing a token crowdsale.
310  * Crowdsales have a start and end timestamps, where Contributors can make
311  * token Contributions and the crowdsale will assign them tokens based
312  * on a token per ETH rate. Funds collected are forwarded to a wallet
313  * as they arrive. The contract requires a MintableToken that will be
314  * minted as contributions arrive, note that the crowdsale contract
315  * must be owner of the token in order to be able to mint it.
316  */
317 contract Crowdsale is Ownable {
318   using SafeMath for uint256;
319   BVA public token;
320   //Start timestamps where investments are allowed
321   uint256 public startPreICO;
322   uint256 public endPreICO;  
323   uint256 public startICO;
324   uint256 public endICO;
325   //Hard cap
326   uint256 public sumHardCapPreICO;
327   uint256 public sumHardCapICO;
328   uint256 public sumPreICO;
329   uint256 public sumICO;
330   //Min Max Investment
331   uint256 public minInvestmentPreICO;
332   uint256 public minInvestmentICO;
333   uint256 public maxInvestmentICO;
334   //rate
335   uint256 public ratePreICO; 
336   uint256 public rateICO;
337   //address where funds are collected
338   address public wallet;
339   //referral system
340   uint256 public maxRefererTokens;
341   uint256 public allRefererTokens;
342 /**
343 * event for token Procurement logging
344 * @param contributor who Pledged for the tokens
345 * @param beneficiary who got the tokens
346 * @param value weis Contributed for Procurement
347 * @param amount amount of tokens Procured
348 */
349   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
350   
351   function Crowdsale() public {
352     token = createTokenContract();
353     //Hard cap
354     sumHardCapPreICO = 15000000 * 1 ether;
355     sumHardCapICO = 1000000 * 1 ether;
356     //referral system
357     maxRefererTokens = 2500000 * 1 ether;
358     //Min Max Investment
359     minInvestmentPreICO = 3 * 1 ether;
360     minInvestmentICO = 100000000000000000; //0.1 ether
361     maxInvestmentICO = 5 * 1 ether;
362     //rate;
363     ratePreICO = 1500;
364     rateICO = 1000;    
365     // address where funds are collected
366     wallet = 0x00a134aE23247c091Dd4A4dC1786358f26714ea3;
367   }
368 
369   function setRatePreICO(uint256 _ratePreICO) public onlyOwner  {
370     ratePreICO = _ratePreICO;
371   } 
372   
373   function setRateICO(uint256 _rateICO) public onlyOwner  {
374     rateICO = _rateICO;
375   }  
376   
377   function setStartPreICO(uint256 _startPreICO) public onlyOwner  {
378     //require(_startPreICO < endPreICO);  
379     startPreICO = _startPreICO;
380   }   
381 
382   function setEndPreICO(uint256 _endPreICO) public onlyOwner  {
383     //require(_endPreICO > startPreICO);
384     //require(_endPreICO < startICO);
385     endPreICO = _endPreICO;
386   }
387 
388   function setStartICO(uint256 _startICO) public onlyOwner  {
389     //require(_startICO > endPreICO); 
390     //require(_startICO < endICO);  
391     startICO = _startICO;
392   }
393 
394   function setEndICO(uint256 _endICO) public onlyOwner  {
395     //require(_endICO > startICO); 
396     endICO = _endICO;
397   }
398   
399   // fallback function can be used to Procure tokens
400   function () external payable {
401     procureTokens(msg.sender);
402   }
403   
404   function createTokenContract() internal returns (BVA) {
405     return new BVA();
406   }
407   
408   function adjustHardCap(uint256 _value) internal {
409     //PreICO   
410     if (now >= startPreICO && now < endPreICO){
411       sumPreICO = sumPreICO.add(_value);
412     }  
413     //ICO   
414     if (now >= startICO && now < endICO){
415       sumICO = sumICO.add(_value);
416     }       
417   }  
418 
419   function checkHardCap(uint256 _value) view public {
420     //PreICO   
421     if (now >= startPreICO && now < endPreICO){
422       require(_value.add(sumPreICO) <= sumHardCapPreICO);
423     }  
424     //ICO   
425     if (now >= startICO && now < endICO){
426       require(_value.add(sumICO) <= sumHardCapICO);
427     }       
428   } 
429   
430   function checkMinMaxInvestment(uint256 _value) view public {
431     //PreICO   
432     if (now >= startPreICO && now < endPreICO){
433       require(_value >= minInvestmentPreICO);
434     }  
435     //ICO   
436     if (now >= startICO && now < endICO){
437       require(_value >= minInvestmentICO);
438       require(_value <= maxInvestmentICO);
439     }       
440   }
441   
442   function bytesToAddress(bytes source) internal pure returns(address) {
443     uint result;
444     uint mul = 1;
445     for(uint i = 20; i > 0; i--) {
446       result += uint8(source[i-1])*mul;
447       mul = mul*256;
448     }
449     return address(result);
450   }
451   
452   function procureTokens(address _beneficiary) public payable {
453     uint256 tokens;
454     uint256 weiAmount = msg.value;
455     address _this = this;
456     uint256 rate;
457     address referer;
458     uint256 refererTokens;
459     require(now >= startPreICO);
460     require(now <= endICO);
461     require(_beneficiary != address(0));
462     checkMinMaxInvestment(weiAmount);
463     rate = getRate();
464     tokens = weiAmount.mul(rate);
465     //referral system
466 	if(msg.data.length == 20) {
467       referer = bytesToAddress(bytes(msg.data));
468       require(referer != msg.sender);
469 	  //add tokens to the referrer
470       refererTokens = tokens.mul(5).div(100);
471     }
472     checkHardCap(tokens.add(refererTokens));
473     adjustHardCap(tokens.add(refererTokens));
474     wallet.transfer(_this.balance);
475 	if (refererTokens != 0 && allRefererTokens.add(refererTokens) <= maxRefererTokens){
476 	  allRefererTokens = allRefererTokens.add(refererTokens);
477       token.mint(referer, refererTokens);	  
478 	}    
479     token.mint(_beneficiary, tokens);
480     emit TokenProcurement(msg.sender, _beneficiary, weiAmount, tokens);
481   }
482   
483   function getRate() public view returns (uint256) {
484     uint256 rate;
485     //PreICO   
486     if (now >= startPreICO && now < endPreICO){
487       rate = ratePreICO;
488     }  
489     //ICO   
490     if (now >= startICO && now < endICO){
491       rate = rateICO;
492     }      
493     return rate;
494   }  
495 }