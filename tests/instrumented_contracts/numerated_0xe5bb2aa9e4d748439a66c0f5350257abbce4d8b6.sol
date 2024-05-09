1 pragma solidity ^0.4.15;
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public constant returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public constant returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    */
200   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 contract MintableToken is StandardToken, Ownable{
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished(); 
228   uint256 public tokensMinted = 0; 
229   bool public mintingFinished = false;
230 
231   modifier canMint() {
232     require(!mintingFinished);
233     _;
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
243     /** Modified to handle multiple capped crowdsales */
244     _amount = _amount * 1 ether;
245     require(tokensMinted.add(_amount)<=totalSupply); 
246     tokensMinted = tokensMinted.add(_amount);
247     //Zappelin Standard code 
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(0x0, _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() onlyOwner public returns (bool) {
259     mintingFinished = true;
260     MintFinished();
261     return true;
262   }
263 }
264 
265 
266 /**
267  * @title Wand token
268  * @dev Customized mintable ERC20 Token  
269  * @dev Token to support multiple Capped CrowdSales. i.e. every crowdsale with capped token limit and also
270         we will be able to increase total token supply based on requirements
271  */
272 contract WandToken is Ownable, MintableToken { 
273   //Event for Presale transfers
274   event TokenPreSaleTransfer(address indexed purchaser, address indexed beneficiary, uint256 amount);
275   
276   // Token details
277   string public constant name = "Wand Token";
278   string public constant symbol = "WAND";
279 
280   // 18 decimal places, the same as ETH.
281   uint8 public constant decimals = 18;
282 
283   /**
284     @dev Constructor. Sets the initial supplies and transfer advisor/founders/presale tokens to the given account
285     @param _owner The address the account nto which presale tokens + Advisors/founders tokens transferred
286    */
287   function WandToken(address _owner) {
288       //Total of 75M tokens
289       totalSupply = 75 * 10**24;  
290 
291       // 17M tokens for Funders+advisors, 3.4M for PreSales
292       tokensMinted = tokensMinted.add(20400000 * (1 ether));
293       balances[_owner] = 20400000 * 1 ether;
294   }   
295 
296   /**
297     @dev function to handle presale trasnfers manually. Only owner can execute the contract
298     @param _accounts buyers accounts that will receive the presale tokens
299     @param _tokens   Amount of the tokens to be transferred to each account in _accounts list 
300     @return A boolean that indicates if the operation is successful.
301    */
302   function batchTransfers(address[] _accounts, uint256[] _tokens) onlyOwner public returns (bool) {
303     require(_accounts.length > 0);
304     require(_accounts.length == _tokens.length); 
305     for (uint i = 0; i < _accounts.length; i++) {
306       require(_accounts[i] != 0x0);
307       require(_tokens[i] > 0); 
308       transfer(_accounts[i], _tokens[i] * 1 ether);
309       TokenPreSaleTransfer(msg.sender, _accounts[i], _tokens[i]); 
310     }
311     return true;   
312   }
313   
314   /**
315     @dev function to raise the total supply. Method can be executed only by its owner
316     @param _supply delta number of tokens to be added to total supply 
317     @return A boolean that indicates if the operation is successful.
318    */
319   function raiseInitialSupply(uint256 _supply) onlyOwner public returns (bool) {
320       totalSupply = totalSupply.add(_supply * 1 ether);
321       return true;
322   }
323 }
324 
325 /**
326  * @title Wandx CrowSale/ICO contract 
327  * @dev It allows multiple Capped CrowdSales. i.e. every crowdsale with capped token limit. 
328  * @dev exposes 2 more proxy methods from token contract which can be executed only by this contract owner
329  */
330 contract WandCrowdsale is Ownable
331 { 
332     using SafeMath for uint256; 
333      
334     // The token being sold
335     WandToken public token;  
336     // the account tp which all incoming ether will be transferred
337     address public wallet;
338     // Flag to track the crowdsale status (Active/InActive)
339     bool public crowdSaleOn = false;  
340 
341     // Current crowsale sate variables
342     uint256 public cap = 0;  // Max allowed tokens to avaialble
343     uint256 public startTime; // Crowdsale start time
344     uint256 public endTime;  // Crowdsale end time
345     uint256 public weiRaised = 0;  // Total amount ether/wei collected
346     uint256 public tokensMinted = 0; // Total number of tokens minted/sold so far in this crowdsale
347     uint256[] public discountedRates ; // Discount per slot
348     uint256[] public crowsaleSlots ; // List of slots
349     
350     // Event to be registered when a successful token purchase happens
351     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
352     
353     /** Modifiers to verify the status of the crowdsale*/
354     modifier activeCrowdSale() {
355         require(crowdSaleOn);
356         _;
357     } 
358     modifier inactiveCrowdSale() {
359         require(!crowdSaleOn);
360         _;
361     } 
362     
363     /**
364         @dev constructor. Intializes the wallets and tokens to be traded using this contract
365      */
366     function WandCrowdsale() { 
367         wallet = msg.sender;  
368         token = new WandToken(msg.sender);
369     }
370     
371     /**
372       @dev proxy method for Wand Tokens batch transfers method, so that contract owner can call token methods
373       @param _accounts buyers accounts that will receive the presale tokens
374       @param _tokens   Amount of the tokens to be transferred to each account in _accounts list 
375       @return A boolean that indicates if the operation is successful. 
376      */
377     function batchTransfers(address[] _accounts, uint256[] _tokens) onlyOwner public returns (bool) {
378         require(_accounts.length > 0);
379         require(_accounts.length == _tokens.length); 
380         token.batchTransfers(_accounts,_tokens);
381         return true;
382     }
383     
384     /**
385       @dev proxy method for Wand Tokens raiseInitialSupply method, so that contract owner can call token methods
386       @param _supply delta number of tokens to be added to total supply 
387       @return A boolean that indicates if the operation is successful.
388      */
389     function raiseInitialSupply(uint256 _supply) onlyOwner public returns (bool) {
390         require(_supply > 0);
391         token.raiseInitialSupply(_supply);
392         return true;
393     }
394     
395     /**
396       @dev function to start the crowdsale with predefined timeslots and discounts. it will be called once for every crowdsale session and 
397            it can be called only its owner
398       @param _startTime at which crowdsale begins
399       @param _endTime at which crowdsale stops
400       @param _cap is number of tokens available during the crowdsale
401       @param _crowsaleSlots array of time slots
402       @param _discountedRates array of discounts 
403       @return A boolean that indicates if the operation is successful
404      */
405     function startCrowdsale(uint256 _startTime, uint256 _endTime,  uint256 _cap, uint256[] _crowsaleSlots, uint256[] _discountedRates) inactiveCrowdSale onlyOwner public returns (bool) {  
406         require(_cap > 0);   
407         require(_crowsaleSlots.length > 0); 
408         require(_crowsaleSlots.length == _discountedRates.length);
409         require(_startTime >= uint256(now));  
410         require( _endTime > _startTime); 
411         
412         //sets the contract state for this crowdsale
413         cap = _cap * 1 ether;  //Normalized the cap to operate at wei units level
414         startTime = _startTime;
415         endTime = _endTime;    
416         crowdSaleOn = true;
417         weiRaised = 0;
418         tokensMinted = 0;
419         discountedRates = _discountedRates;
420         crowsaleSlots = _crowsaleSlots;
421         return true;
422     }  
423 
424     /**
425       @dev function to stop crowdsale session.it will be called once for every crowdsale session and it can be called only its owner
426       @return A boolean that indicates if the operation is successful
427      */
428     function endCrowdsale() activeCrowdSale onlyOwner public returns (bool) {
429         endTime = now;  
430         if(tokensMinted < cap){
431             uint256 leftoverTokens = cap.sub(tokensMinted);
432             require(tokensMinted.add(leftoverTokens) <= cap);
433             tokensMinted = tokensMinted.add(leftoverTokens);
434             token.mint(owner, leftoverTokens.div(1 ether)); 
435         }
436         crowdSaleOn = false;
437         return true;
438     }   
439     
440     /**
441       @dev function to calculate and return the discounted token rate based on the current timeslot
442       @return _discountedRate for the current timeslot
443      */
444     function findDiscount() constant private returns (uint256 _discountedRate) {
445         uint256 elapsedTime = now.sub(startTime);
446         for(uint i=0; i<crowsaleSlots.length; i++){
447             if(elapsedTime >= crowsaleSlots[i]) {
448                 elapsedTime = elapsedTime.sub(crowsaleSlots[i]);
449             }
450             else {
451                 _discountedRate = discountedRates[i];
452                 break;
453             }
454         } 
455     }
456     
457     /**
458       @dev  fallback function can be used to buy tokens
459       */
460     function () payable {
461         buyTokens(msg.sender);
462     }
463   
464     /**
465       @dev  low level token purchase function
466       */
467     function buyTokens(address beneficiary) activeCrowdSale public payable {
468         require(beneficiary != 0x0); 
469         require(now >= startTime);
470         require(now <= endTime);
471         require(msg.value != 0);   
472         
473         // amount ether sent to the contract.. normalized to wei
474         uint256 weiAmount = msg.value; 
475         weiRaised = weiRaised.add(weiAmount); 
476         
477         // apply the discount based on timeslot and get the token rate (X tokens per 1 ether)
478         var currentRate = findDiscount();
479         // Find out Token value in wei ( Y wei per 1 Token)
480         uint256 rate = uint256(1 * 1 ether).div(currentRate); 
481         require(rate > 0);
482         // Find out the number of tokens for given wei and normalize to ether so that tokens can be minted
483         // by token contract
484         uint256 numTokens = weiAmount.div(rate); 
485         require(numTokens > 0); 
486         require(tokensMinted.add(numTokens.mul(1 ether)) <= cap);
487         tokensMinted = tokensMinted.add(numTokens.mul(1 ether));
488         
489         // Mint the tokens and trasfer to the buyer
490         token.mint(beneficiary, numTokens);
491         TokenPurchase(msg.sender, beneficiary, weiAmount, numTokens); 
492         // Transfer the ether to Wallet and close the purchase
493         wallet.transfer(weiAmount);
494     } 
495 }