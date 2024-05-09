1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Basic token
27  * @dev Basic version of StandardToken, with no allowances.
28  */
29 contract BasicToken is ERC20Basic {
30   using SafeMath for uint256;
31 
32   mapping(address => uint256) balances;
33 
34   /**
35   * @dev transfer token for a specified address
36   * @param _to The address to transfer to.
37   * @param _value The amount to be transferred.
38   */
39   function transfer(address _to, uint256 _value) public returns (bool) {
40     require(_to != address(0));
41     require(_value <= balances[msg.sender]);
42 
43     // SafeMath.sub will throw if there is not enough balance.
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   /**
51   * @dev Gets the balance of the specified address.
52   * @param _owner The address to query the the balance of.
53   * @return An uint256 representing the amount owned by the passed address.
54   */
55   function balanceOf(address _owner) public view returns (uint256 balance) {
56     return balances[_owner];
57   }
58 
59 }
60 
61 /**
62  * @title Standard ERC20 token
63  *
64  * @dev Implementation of the basic standard token.
65  * @dev https://github.com/ethereum/EIPs/issues/20
66  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
67  */
68 contract StandardToken is ERC20, BasicToken {
69 
70   mapping (address => mapping (address => uint256)) internal allowed;
71 
72 
73   /**
74    * @dev Transfer tokens from one address to another
75    * @param _from address The address which you want to send tokens from
76    * @param _to address The address which you want to transfer to
77    * @param _value uint256 the amount of tokens to be transferred
78    */
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[_from]);
82     require(_value <= allowed[_from][msg.sender]);
83 
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   /**
92    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
93    *
94    * Beware that changing an allowance with this method brings the risk that someone may use both the old
95    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98    * @param _spender The address which will spend the funds.
99    * @param _value The amount of tokens to be spent.
100    */
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Function to check the amount of tokens that an owner allowed to a spender.
109    * @param _owner address The address which owns the funds.
110    * @param _spender address The address which will spend the funds.
111    * @return A uint256 specifying the amount of tokens still available for the spender.
112    */
113   function allowance(address _owner, address _spender) public view returns (uint256) {
114     return allowed[_owner][_spender];
115   }
116 
117   /**
118    * @dev Increase the amount of tokens that an owner allowed to a spender.
119    *
120    * approve should be called when allowed[_spender] == 0. To increment
121    * allowed value is better to use this function to avoid 2 calls (and wait until
122    * the first transaction is mined)
123    * From MonolithDAO Token.sol
124    * @param _spender The address which will spend the funds.
125    * @param _addedValue The amount of tokens to increase the allowance by.
126    */
127   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
128     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130     return true;
131   }
132 
133   /**
134    * @dev Decrease the amount of tokens that an owner allowed to a spender.
135    *
136    * approve should be called when allowed[_spender] == 0. To decrement
137    * allowed value is better to use this function to avoid 2 calls (and wait until
138    * the first transaction is mined)
139    * From MonolithDAO Token.sol
140    * @param _spender The address which will spend the funds.
141    * @param _subtractedValue The amount of tokens to decrease the allowance by.
142    */
143   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154 }
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167 
168   /**
169    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170    * account.
171    */
172   function Ownable() public {
173     owner = msg.sender;
174   }
175 
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(msg.sender == owner);
182     _;
183   }
184 
185 
186   /**
187    * @dev Allows the current owner to transfer control of the contract to a newOwner.
188    * @param newOwner The address to transfer ownership to.
189    */
190   function transferOwnership(address newOwner) public onlyOwner {
191     require(newOwner != address(0));
192     OwnershipTransferred(owner, newOwner);
193     owner = newOwner;
194   }
195 
196 }
197 /**
198  * @title Mintable token
199  * @dev Simple ERC20 Token example, with mintable token creation
200  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
201  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
202  */
203 
204 contract MintableToken is StandardToken, Ownable {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207 
208   bool public mintingFinished = false;
209 
210 
211   modifier canMint() {
212     require(!mintingFinished);
213     _;
214   }
215 
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
223     _amount = _amount * 1 ether;
224     totalSupply = totalSupply.add(_amount);
225     balances[_to] = balances[_to].add(_amount);
226     Mint(_to, _amount);
227     Transfer(address(0), _to, _amount);
228     return true;
229   }
230 
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235   function finishMinting() onlyOwner canMint public returns (bool) {
236     mintingFinished = true;
237     MintFinished();
238     return true;
239   }
240 }
241 
242 
243 
244 /**
245  * @title Token Wrapper with constructor
246  * @dev Customized mintable ERC20 Token
247  * @dev Token to support 2 owners only.
248  */
249 contract PUBLICCOIN is Ownable, MintableToken {
250   //Event for Presale transfers
251   //event TokenPreSaleTransfer(address indexed purchaser, address indexed beneficiary, uint256 amount);
252 
253   // Token details
254   string public constant name = "Public Coin";
255   string public constant symbol = "PUBLIC";
256 
257   // 18 decimal places, the same as ETH.
258   uint8 public constant decimals = 18;
259 
260   /**
261     @dev Constructor. Sets the initial supplies and transfer advisor/founders/presale tokens to the given account
262     @param _owner1 The address of the first owner
263     @param _owner1Percentage The preallocate percentage of tokens belong to the first owner
264     @param _owner2 The address of the second owner
265     @param _owner2Percentage The preallocate percentage of tokens belong to the second owner
266     @param _cap the maximum totalsupply in number of tokens //before multiply to 10**18
267    */
268   function PUBLICCOIN (address _owner1, uint8 _owner1Percentage, address _owner2, uint8 _owner2Percentage, uint256 _cap) public {
269       //Total of 17M tokens
270       require(_owner1Percentage+_owner2Percentage<50);//sanity check
271       require(_cap >0);
272       totalSupply = 0; //initialize total supply
273       // 12% for owner1, 6% for owner 2
274       mint(_owner1, _cap *_owner1Percentage / 100);
275       mint(_owner2, _cap *_owner2Percentage / 100);
276 
277   }
278 
279 }
280 
281 /**
282  * @title SafeMath
283  * @dev Math operations with safety checks that throw on error
284  */
285 library SafeMath {
286   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287     if (a == 0) {
288       return 0;
289     }
290     uint256 c = a * b;
291     assert(c / a == b);
292     return c;
293   }
294 
295   function div(uint256 a, uint256 b) internal pure returns (uint256) {
296     // assert(b > 0); // Solidity automatically throws when dividing by 0
297     uint256 c = a / b;
298     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299     return c;
300   }
301 
302   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303     assert(b <= a);
304     return a - b;
305   }
306 
307   function add(uint256 a, uint256 b) internal pure returns (uint256) {
308     uint256 c = a + b;
309     assert(c >= a);
310     return c;
311   }
312 }
313 
314 /**
315  * @title Token Generation Event for PublicCoin
316  * credit: part of this contract was created from OpenZeppelin Code
317  * @dev It allows multiple Capped CrowdSales. i.e. every crowdsale with capped token limit.
318  * Simplified the deployment function for owner, just click & start, no configuration parameters
319  */
320 contract Crowdsale is Ownable
321 {
322     using SafeMath for uint256;
323 
324     // The token being sold
325     PUBLICCOIN public token;
326     // the account to which all incoming ether will be transferred
327     // Flag to track the crowdsale status (Active/InActive)
328     bool public crowdSaleOn = false;
329 
330     // Current crowdsale sate variables
331     uint256 constant totalCap = 17*10**6;  // Max avaialble number of tokens in total including presale (unit token)
332     uint256 constant crowdSaleCap = 14*10**6*(1 ether);  // Max avaialble number of tokens for crowdsale 18 M (unit wei)
333     uint256 constant bonusPeriod = 1 days; //change to 1 days when deploying
334     uint256 constant tokensPerEther = 3750;
335     uint256 public startTime; // Crowdsale start time
336     uint256 public endTime;  // Crowdsale end time
337     uint256 public weiRaised = 0;  // Total amount ether/wei collected
338     uint256 public tokensMinted = 0; // Total number of tokens minted/sold so far in this crowdsale
339     uint256 public currentRate = 3750;
340     //first_owner receives 90% of ico fund in eth, second_owner receives 10%.
341     //first_owner keeps 12% of token, second_owner keeps 6% token, 82% token for public sale
342     //For transparency this must be hardcoded and uploaded to etherscan.io
343     address constant firstOwner = 0xf878bDc344097449Df3F2c2DC6Ed491e9DeF71f5;
344     address constant secondOwner = 0x0B993E8Ee11B18BD99FCf7b2df5555385A661f7e;
345     uint8 constant firstOwnerETHPercentage= 90;
346     uint8 constant secondOwnerETHPercentage= 10;
347     uint8 constant firstOwnerTokenPercentage= 12;
348     uint8 constant secondOwnerTokenPercentage= 6;
349     uint256 constant minPurchase = (1*1 ether)/10; //0.1 eth minimum
350 
351     // Event to be registered when a successful token purchase happens
352     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
353 
354     /** Modifiers to verify the status of the crowdsale*/
355     modifier activeCrowdSale() {
356         require(crowdSaleOn);
357         _;
358     }
359     modifier inactiveCrowdSale() {
360         require(!crowdSaleOn);
361         _;
362     }
363 
364     /**
365         @dev constructor. Intializes the token to be traded using this contract
366      */
367     function Crowdsale() public {
368         token = new PUBLICCOIN(firstOwner,firstOwnerTokenPercentage,secondOwner,secondOwnerTokenPercentage, totalCap);
369     }
370 
371     /**
372       @dev function to start the crowdsale. it will be called once for each crowdsale session
373       @return A boolean that indicates if the operation is successful
374      */
375     function startCrowdsale() inactiveCrowdSale onlyOwner public returns (bool) {
376         startTime =  uint256(now);
377         //endTime = now + 30 days;
378         endTime = now + 3*bonusPeriod;
379         crowdSaleOn = true;
380         weiRaised = 0;
381         tokensMinted = 0;
382         return true;
383     }
384 
385     /**
386       @dev function to stop crowdsale session.it will be called once for every crowdsale session and it can be called only its owner
387       @return A boolean that indicates if the operation is successful
388      */
389     function endCrowdsale() activeCrowdSale onlyOwner public returns (bool) {
390         require(now >= endTime);
391         crowdSaleOn = false;
392         token.finishMinting();
393         return true;
394     }
395 
396     /**
397       @dev function to calculate and return the discounted token rate based on the current timeslot
398       @return _discountedRate for the current timeslot
399       return rate of Y wei per 1 Token)
400       base rate without bonus : 1 ether = 3 750 tokens
401       rate changes after 11 days
402       the first 1 day: 35% bonus, next 3 days: 15% bonus , last 27 days : 0%
403       hardcoded
404      */
405     function findCurrentRate() constant private returns (uint256 _discountedRate) {
406 
407         uint256 elapsedTime = now.sub(startTime);
408         uint256 baseRate = (1*1 ether)/tokensPerEther;
409 
410         if (elapsedTime <= bonusPeriod){ // x<= 1days
411             _discountedRate = baseRate.mul(100).div(135);
412         }else{
413             if (elapsedTime < 2*bonusPeriod){ //1days < x <= 3 days
414               _discountedRate = baseRate.mul(100).div(115);
415               }else{
416               _discountedRate = baseRate;
417             }
418         }
419 
420     }
421 
422     /**
423       @dev  fallback function can be used to buy tokens
424       */
425     function () payable public {
426         buyTokens(msg.sender);
427     }
428 
429     /**
430       @dev  low level token purchase function
431       */
432     function buyTokens(address beneficiary) activeCrowdSale public payable {
433         require(beneficiary != 0x0);
434         require(now >= startTime);
435         require(now <= endTime);
436         require(msg.value >= minPurchase); //enforce minimum value of a tx
437 
438         // amount ether sent to the contract.. normalized to wei
439         uint256 weiAmount = msg.value;
440         weiRaised = weiRaised.add(weiAmount);
441 
442 
443         // Find out Token value in wei ( Y wei per 1 Token)
444         uint256 rate = findCurrentRate();
445         //uint256 rate = uint256(1 * 1 ether).div(currentRate);
446         require(rate > 0);
447         //update public variable for viewing only, as requested
448         currentRate = (1*1 ether)/rate;
449         // Find out the number of tokens for given wei and normalize to ether so that tokens can be minted
450         // by token contract
451         uint256 numTokens = weiAmount.div(rate);
452         require(numTokens > 0);
453         require(tokensMinted.add(numTokens.mul(1 ether)) <= crowdSaleCap);
454         tokensMinted = tokensMinted.add(numTokens.mul(1 ether));
455 
456         // Mint the tokens and trasfer to the buyer
457         token.mint(beneficiary, numTokens);
458         TokenPurchase(msg.sender, beneficiary, weiAmount, numTokens);
459         // Transfer the ether to owners according to their share and close the purchase
460         firstOwner.transfer(weiAmount*firstOwnerETHPercentage/100);
461         secondOwner.transfer(weiAmount*secondOwnerETHPercentage/100);
462 
463     }
464 
465     // ETH balance is always expected to be 0 after the crowsale.
466     // but in case something went wrong, we use this function to extract the eth.
467     // Security idea from kyber.network crowdsale
468     // This should never be used
469     function emergencyDrain(ERC20 anyToken) inactiveCrowdSale onlyOwner public returns(bool){
470         if( this.balance > 0 ) {
471             owner.transfer( this.balance );
472         }
473 
474         if( anyToken != address(0x0) ) {
475             assert( anyToken.transfer(owner, anyToken.balanceOf(this)) );
476         }
477 
478         return true;
479     }
480 
481 }