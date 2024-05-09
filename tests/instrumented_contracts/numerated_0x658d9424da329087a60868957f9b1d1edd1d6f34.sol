1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title FornicoinCrowdsale
5  * The Crowdsale contract for the Fornicoin Project.
6  * Read more at fornicoin.network
7  * <info (at) fornicoin.network>
8  */
9 
10 
11  /*
12  * This is the smart contract for the Fornicoin token.
13  * More information can be found on our website at: https://fornicoin.network
14  * Created by the Fornicoin Team <info@fornicoin.network>
15  */
16 
17 /**
18  * @title ERC20Basic
19  * @dev Simpler version of ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/179
21  */
22 contract ERC20Basic {
23   uint256 public totalSupply;
24   function balanceOf(address who) public constant returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint _value) public returns (bool) {
77     require(_to != address(0));
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public constant returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117     
118      mapping (address => mapping (address => uint256)) allowed;
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     
129     var _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140   
141     /**
142    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) returns (bool) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifing the amount of tokens still avaible for the spender.
164    */
165   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169 }
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179   /**
180    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181    * account.
182    */
183   function Ownable() {
184     owner = msg.sender;
185   }
186 
187 
188   /**
189    * @dev Throws if called by any account other than the owner.
190    */
191   modifier onlyOwner() {
192     require(msg.sender == owner);
193     _;
194   }
195 
196 }
197 
198 
199 
200  /*
201  * This is the smart contract for the Fornicoin token.
202  * More information can be found on our website at: https://fornicoin.network
203  * Created by the Fornicoin Team <info@fornicoin.network>
204  */
205 
206 contract FornicoinToken is StandardToken, Ownable {
207   using SafeMath for uint256;
208 
209   string public constant name = "Fornicoin";
210   string public constant symbol = "FXX";
211   uint8 public constant decimals = 18;
212 
213   // 100 000 000 Fornicoin tokens created
214   uint256 public constant MAX_SUPPLY = 100000000 * (10 ** uint256(decimals));
215   
216   // admin address for team functions
217   address public admin;
218   uint256 public teamTokens = 25000000 * (10 ** 18);
219   
220   // Top up gas balance
221   uint256 public minBalanceForTxFee = 55000 * 3 * 10 ** 9 wei; // == 55000 gas @ 3 gwei
222   // 800 FXX per ETH as the gas generation price
223   uint256 public sellPrice = 800; 
224   
225   event Refill(uint256 amount);
226   
227   modifier onlyAdmin() {
228     require(msg.sender == admin);
229     _;
230   }
231 
232   function FornicoinToken(address _admin) {
233     totalSupply = teamTokens;
234     balances[msg.sender] = MAX_SUPPLY;
235     admin =_admin;
236   }
237   
238   function setSellPrice(uint256 _price) public onlyAdmin {
239       require(_price >= 0);
240       // FXX can only become stronger
241       require(_price <= sellPrice);
242       
243       sellPrice = _price;
244   }
245   
246   // Update state of contract showing tokens bought
247   function updateTotalSupply(uint256 additions) onlyOwner {
248       require(totalSupply.add(additions) <= MAX_SUPPLY);
249       totalSupply += additions;
250   }
251   
252   function setMinTxFee(uint256 _balance) public onlyAdmin {
253       require(_balance >= 0);
254       // can only add more eth
255       require(_balance > minBalanceForTxFee);
256       
257       minBalanceForTxFee = _balance;
258   }
259   
260   function refillTxFeeMinimum() public payable onlyAdmin {
261       Refill(msg.value);
262   }
263   
264   // Transfers FXX tokens to another address
265   // Utilises transaction fee obfuscation
266   function transfer(address _to, uint _value) public returns (bool) {
267         // Prevent transfer to 0x0 address
268         require (_to != 0x0);
269         // Check for overflows 
270         require (balanceOf(_to) + _value > balanceOf(_to));
271         // Determine if account has necessary funding for another tx
272         if(msg.sender.balance < minBalanceForTxFee && 
273         balances[msg.sender].sub(_value) >= minBalanceForTxFee * sellPrice && 
274         this.balance >= minBalanceForTxFee){
275             sellFXX((minBalanceForTxFee.sub(msg.sender.balance)) *                                 
276                              sellPrice);
277     	        }
278         // Subtract from the sender
279         balances[msg.sender] = balances[msg.sender].sub(_value);
280         // Add the same to the recipient                   
281         balances[_to] = balances[_to].add(_value); 
282         // Send out Transfer event to notify all parties
283         Transfer(msg.sender, _to, _value);
284         return true;
285     }
286 
287     // Sells the amount of FXX to refill the senders ETH balance for another transaction
288     function sellFXX(uint amount) internal returns (uint revenue){
289         // checks if the sender has enough to sell
290         require(balanceOf(msg.sender) >= amount);  
291         // adds the amount to owner's balance       
292         balances[admin] = balances[admin].add(amount);          
293         // subtracts the amount from seller's balance              
294         balances[msg.sender] = balances[msg.sender].sub(amount);   
295         // Determines amount of ether to send to the seller 
296         revenue = amount / sellPrice;
297         msg.sender.transfer(revenue);
298         // executes an event reflecting on the change
299         Transfer(msg.sender, this, amount); 
300         // ends function and returns              
301         return revenue;                                   
302     }
303 }
304 
305 
306 /**
307  * @title FornicoinCrowdsale
308  * The Crowdsale contract for the Fornicoin Project.
309  * Read more at fornicoin.network
310  * <info (at) fornicoin.network>
311  */
312  
313 contract FornicoinCrowdsale {
314   using SafeMath for uint256;
315 
316   // The token being sold
317   FornicoinToken public token;
318 
319   // start and end timestamps where investments are allowed (both inclusive)
320   uint256 public startICOPhaseOne;
321   uint256 public startICOPhaseTwo;
322   uint256 public startICOPhaseThree;
323   uint256 public endICO;
324 
325   // address where funds are collected
326   address public wallet;
327 
328   // how many token units a buyer gets per wei
329   uint256 public phaseOneRate = 1100;
330   uint256 public phaseTwoRate = 1000;
331   uint256 public phaseThreeRate = 850;
332 
333   // amount of raised money in wei
334   uint256 public weiRaised;
335   
336   // admin address to halt contract
337   address public admin;
338   bool public haltSale;
339   uint256 public teamTokens = 25000000 * (10 ** 18);
340   bool public presaleDist = false;
341   
342   modifier onlyAdmin() {
343     require(msg.sender == admin);
344     _;
345   }
346 
347   /**
348    * event for token purchase logging
349    * @param purchaser who paid for the tokens
350    * @param beneficiary who got the tokens
351    * @param value weis paid for purchase
352    * @param amount amount of tokens purchased
353    */
354   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
355   
356   function FornicoinCrowdsale(uint256 _startTime, address _wallet, address _admin) 
357     public 
358     {
359     require(_startTime >= now);
360     require(_wallet != 0x0);
361     
362     token = new FornicoinToken(_admin);
363     startICOPhaseOne = _startTime;
364     startICOPhaseTwo = startICOPhaseOne + 3 days;
365     startICOPhaseThree = startICOPhaseTwo + 4 weeks;
366     endICO = startICOPhaseThree + 15 days;
367     wallet = _wallet;
368     admin = _admin;
369   }
370 
371   // fallback function can be used to buy tokens
372   function () payable {
373     buyTokens(msg.sender);
374   }
375 
376 //   low level token purchase function
377   function buyTokens(address beneficiary) public payable {
378     require(beneficiary != 0x0);
379     require(validPurchase());
380     require(!haltSale);
381 
382     uint256 weiAmount = msg.value;
383     
384     uint256 tokens;
385 
386     // calculate token amount to be created
387     if (now <= startICOPhaseTwo) {
388       tokens = weiAmount.mul(phaseOneRate);
389     } else if (now < startICOPhaseThree){
390       tokens = weiAmount.mul(phaseTwoRate);
391     } else {
392       tokens = weiAmount.mul(phaseThreeRate);
393     }
394     
395     token.updateTotalSupply(tokens);
396 
397     // update state
398     weiRaised = weiRaised.add(weiAmount);
399 
400     token.transfer(beneficiary, tokens);
401     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
402 
403     if (this.balance > 1 ether){
404       forwardFunds();
405     }
406   }
407 
408   // send ether to the fund collection wallet
409   // override to create custom fund forwarding mechanisms
410   function forwardFunds() internal {
411     wallet.transfer(this.balance);
412   }
413 
414   // @return true if the transaction can buy tokens
415   function validPurchase() internal constant returns (bool) {
416     bool withinPeriod = now >= startICOPhaseOne && now <= endICO;
417     bool nonZeroPurchase = msg.value != 0;
418     return withinPeriod && nonZeroPurchase;
419   }
420   
421   // @return currentRate of FXX tokens per ETH
422   function currentRate() public constant returns (uint256) {
423     if (now <= startICOPhaseTwo) {
424       return phaseOneRate;
425     } else if (now <= startICOPhaseThree){
426       return phaseTwoRate;
427     } else {
428       return phaseThreeRate;
429     }
430   }
431   
432   // Withdraw team tokens after 1 year
433   function withdrawTeamTokens() public onlyAdmin returns (bool) {
434     require(now >= startICOPhaseOne + 1 years);
435 
436     token.transfer(wallet, teamTokens);
437     return true;
438   }
439   
440   function distPresale(address _presale, uint256 _tokens) public onlyAdmin {
441       require(_tokens <= 13000000*10**18);
442       require(!presaleDist);
443       presaleDist = true;
444       
445       token.transfer(_presale, _tokens);
446   }
447   
448   //sends any left over funds to the wallet
449   function finalizeSale() public onlyAdmin {
450       require(now > endICO);
451       
452       if (this.balance>0){
453           wallet.transfer(this.balance);
454       }
455       if(token.totalSupply() < token.MAX_SUPPLY()){
456           uint256 difference = token.MAX_SUPPLY().sub(token.totalSupply());
457           token.transfer(wallet, difference);
458           token.updateTotalSupply(difference);
459       }
460   }
461 
462 }