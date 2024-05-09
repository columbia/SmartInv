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
292 contract Bevium is Ownable, MintableToken {
293   using SafeMath for uint256;    
294   string public constant name = "Bevium";
295   string public constant symbol = "BVI";
296   uint32 public constant decimals = 18;
297   address public addressFounders;
298   uint256 public summFounders;
299   function Bevium() public {
300     addressFounders = 0x6e69307fe1fc55B2fffF680C5080774D117f1154;  
301     summFounders = 26400000 * (10 ** uint256(decimals));  
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
319   Bevium public token;
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
337   // address where funds are collected
338   address public wallet;
339   
340 /**
341 * event for token Procurement logging
342 * @param contributor who Pledged for the tokens
343 * @param beneficiary who got the tokens
344 * @param value weis Contributed for Procurement
345 * @param amount amount of tokens Procured
346 */
347   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
348   
349   function Crowdsale() public {
350     token = createTokenContract();
351     // start timestamps where investments are allowed
352     startPreICO = 1535587200;  // Aug 30 2018 00:00:00 +0000
353     endPreICO = 1543536000;  // Nov 30 2018 00:00:00 +0000    
354     startICO = 1543536000;  // Nov 30 2018 00:00:00 +0000
355     endICO = 1577664000;  // Dec 30 2019 00:00:00 +0000
356     //Hard cap
357     sumHardCapPreICO = 22000000 * 1 ether;
358     sumHardCapICO = 6600000 * 1 ether;
359     //Min Max Investment
360     minInvestmentPreICO = 10 * 1 ether;
361     minInvestmentICO = 100000000000000000; //0.1 ether
362     maxInvestmentICO = 5 * 1 ether;
363     //rate;
364     ratePreICO = 1500;
365     rateICO = 1000;    
366     // address where funds are collected
367     wallet = 0x86a639e5587117Fc95517D13168F767226DA6107;
368   }
369 
370   function setRatePreICO(uint _ratePreICO) public onlyOwner  {
371     ratePreICO = _ratePreICO;
372   } 
373   
374   function setRateICO(uint _rateICO) public onlyOwner  {
375     rateICO = _rateICO;
376   }  
377   
378   function setStartPreICO(uint _startPreICO) public onlyOwner  {
379     //require(_startPreICO < endPreICO);  
380     startPreICO = _startPreICO;
381   }   
382 
383   function setEndPreICO(uint _endPreICO) public onlyOwner  {
384     //require(_endPreICO > startPreICO);
385     //require(_endPreICO < startICO);
386     endPreICO = _endPreICO;
387   }
388 
389   function setStartICO(uint _startICO) public onlyOwner  {
390     //require(_startICO > endPreICO); 
391     //require(_startICO < endICO);  
392     startICO = _startICO;
393   }
394 
395   function setEndICO(uint _endICO) public onlyOwner  {
396     //require(_endICO > startICO); 
397     endICO = _endICO;
398   }
399   
400   // fallback function can be used to Procure tokens
401   function () external payable {
402     procureTokens(msg.sender);
403   }
404   
405   function createTokenContract() internal returns (Bevium) {
406     return new Bevium();
407   }
408 
409   function checkHardCap(uint256 _value) view public {
410     //PreICO   
411     if (now >= startPreICO && now < endPreICO){
412       require(_value.add(sumPreICO) <= sumHardCapPreICO);
413     }  
414     //ICO   
415     if (now >= startICO && now < endICO){
416       require(_value.add(sumICO) <= sumHardCapICO);
417     }       
418   } 
419   
420   function adjustHardCap(uint256 _value) public {
421     //PreICO   
422     if (now >= startPreICO && now < endPreICO){
423       sumPreICO = sumPreICO.add(_value);
424     }  
425     //ICO   
426     if (now >= startICO && now < endICO){
427       sumICO = sumICO.add(_value);
428     }       
429   }   
430   
431   function checkMinMaxInvestment(uint256 _value) view public {
432     //PreICO   
433     if (now >= startPreICO && now < endPreICO){
434       require(_value >= minInvestmentPreICO);
435     }  
436     //ICO   
437     if (now >= startICO && now < endICO){
438       require(_value >= minInvestmentICO);
439       require(_value <= maxInvestmentICO);
440     }       
441   }   
442   
443   function getRate() public view returns (uint256) {
444     uint256 rate;
445     //PreICO   
446     if (now >= startPreICO && now < endPreICO){
447       rate = ratePreICO;
448     }  
449     //ICO   
450     if (now >= startICO && now < endICO){
451       rate = rateICO;
452     }      
453     return rate;
454   }  
455   
456   function procureTokens(address _beneficiary) public payable {
457     uint256 tokens;
458     uint256 weiAmount = msg.value;
459     address _this = this;
460     uint256 rate;
461     require(now >= startPreICO);
462     require(now <= endICO);
463     require(_beneficiary != address(0));
464     checkMinMaxInvestment(weiAmount);
465     rate = getRate();
466     tokens = weiAmount.mul(rate);
467     checkHardCap(tokens);
468     adjustHardCap(tokens);
469     wallet.transfer(_this.balance);
470     token.mint(_beneficiary, tokens);
471     emit TokenProcurement(msg.sender, _beneficiary, weiAmount, tokens);
472   }
473 }