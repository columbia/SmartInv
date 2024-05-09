1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     //SafeMath library for preventing overflow when dealing with uint256 in solidity
5 
6    /**
7    * @dev Multiplies two numbers, throws on overflow.
8    */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     /**
29     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 
47 contract ERC20 {
48     //ERC20 contract used as an interface. Implementation of functions provided in the derived contract.
49 
50     string public NAME;
51     string public SYMBOL;
52     uint8 public DECIMALS = 18; // 18 DECIMALS is the strongly suggested default, avoid changing it
53 
54     //total supply (TOTALSUPPLY) is declared private and can be accessed via totalSupply()
55     uint private TOTALSUPPLY;
56 
57     // Balances for each account
58     mapping(address => uint256) balances;
59 
60     // Owner of account approves the transfer of an amount to another account
61     //This is a mapping of a mapping
62     // This mapping keeps track of the allowances given
63     mapping(address => mapping (address => uint256)) allowed;
64 
65                  //*** ERC20 FUNCTIONS ***//
66     //1
67     //Allows an instance of a contract to calculate and return the total amount
68     //of the token that exists.
69     function totalSupply() public constant returns (uint256 _totalSupply);
70 
71     //2
72     //Allows a contract to store and return the balance of the provided address (parameter)
73     function balanceOf(address _owner) public constant returns (uint256 balance);
74 
75     //3
76     //Lets the caller send a given amount(_amount) of the token to another address(_to).
77     //Note: returns a boolean indicating whether transfer was successful
78     function transfer(address _to, uint256 _value) public returns (bool success);
79 
80     //4
81     //Owner "approves" the given address to withdraw instances of the tokens from the owners address
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 
84     //5
85     //Lets an "approved" address transfer the approved amount from the address that called approve()
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
87 
88     //6
89     //returns the amount of tokens approved by the owner that can *Still* be transferred
90     //to the spender's account using the transferFrom method.
91     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
92 
93             //***ERC20 Events***//
94     //Event 1
95     // Triggered whenever approve(address _spender, uint256 _value) is called.
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     //Event 2
99     // Triggered when tokens are transferred.
100     event Transfer(address indexed _from, address indexed _to, uint256 _value);
101 }
102 
103 
104 /**
105  * @title Ownable
106  * @dev The Ownable contract has an owner address, and provides basic authorization control
107  * functions, this simplifies the implementation of "user permissions".
108  */
109 contract Ownable {
110     address public owner;
111 
112     //Event triggered when owner address is changed.
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     /**
116      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
117      * account.
118      */
119     constructor() public {
120         owner = msg.sender;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130 
131     /**
132      * @dev Allows the current owner to transfer control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function transferOwnership(address newOwner) public onlyOwner {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(owner, newOwner);
138         owner = newOwner;
139     }
140 
141 }
142 
143 
144 contract Bitcub is Ownable, ERC20 {
145     using SafeMath for uint256;
146 
147     string public constant NAME = "Bitcub";
148     string public constant SYMBOL = "BCU";
149     uint8 public constant DECIMALS = 18; // 18 DECIMALS is the strongly suggested default, avoid changing it
150 
151     //total supply (TOTALSUPPLY) is declared private and constant and can be accessed via totalSupply()
152     uint private constant TOTALSUPPLY = 500000000*(10**18);
153 
154     // Balances for each account
155     mapping(address => uint256) balances;
156 
157     // Owner of account approves the transfer of an amount to another account
158     //This is a mapping of a mapping
159     // This mapping keeps track of the allowances given
160     mapping(address => mapping (address => uint256)) allowed;
161 
162     //Constructor FOR BITCUB TOKEN
163     constructor() public {
164         //establishes ownership of the contract upon creation
165         Ownable(msg.sender);
166 
167         /* IMPLEMENTING ALLOCATION OF TOKENS */
168         balances[0xaf0A558783E92a1aEC9dd2D10f2Dc9b9AF371212] = 150000000*(10**18);
169         /* Transfer Events for the allocations */
170         emit Transfer(address(0), 0xaf0A558783E92a1aEC9dd2D10f2Dc9b9AF371212, 150000000*(10**18));
171 
172         //sends all the unallocated tokens (350,000,000 tokens) to the address of the contract creator (The Crowdsale Contract)
173         balances[msg.sender] = TOTALSUPPLY.sub(150000000*(10**18)); 
174         //Transfer event for sending tokens to Crowdsale Contract
175         emit Transfer(address(0), msg.sender, TOTALSUPPLY.sub(150000000*(10**18)));
176     }
177 
178                  //*** ERC20 FUNCTIONS ***//
179     //1
180     /**
181     * @dev total number of tokens in existence
182     */
183     function totalSupply() public constant returns (uint256 _totalSupply) {
184         //set the named return variable as the global variable totalSupply
185         _totalSupply = TOTALSUPPLY;
186     }
187 
188     //2
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param _owner The address to query the the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address _owner) public view returns (uint256 balance) {
195         return balances[_owner];
196     }
197 
198     //3
199     /**
200     * @dev transfer token for a specified address
201     * @param _to The address to transfer to.
202     * @param _value The amount to be transferred.
203     */
204     //Note: returns a boolean indicating whether transfer was successful
205     function transfer(address _to, uint256 _value) public returns (bool success) {
206         require(_to != address(0)); //not sending to burn address
207         require(_value <= balances[msg.sender]); // If the sender has sufficient funds to send
208         require(_value>0);// and the amount is not zero or negative
209 
210         // SafeMath.sub will throw if there is not enough balance.
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit Transfer(msg.sender, _to, _value);
214         return true;
215     }
216 
217     //4
218     //Owner "approves" the given address to withdraw instances of the tokens from the owners address
219     /**
220        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221        *
222        * Beware that changing an allowance with this method brings the risk that someone may use both the old
223        * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224        * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226        * @param _spender The address which will spend the funds.
227        * @param _value The amount of tokens to be spent.
228        */
229     function approve(address _spender, uint256 _value) public returns (bool) {
230         allowed[msg.sender][_spender] = _value;
231         emit Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     //5
236     //Lets an "approved" address transfer the approved amount from the address that called approve()
237     /**
238      * @dev Transfer tokens from one address to another
239      * @param _from address The address which you want to send tokens from
240      * @param _to address The address which you want to transfer to
241      * @param _value uint256 the amount of tokens to be transferred
242      */
243     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
244         require(_to != address(0));
245         require(_value <= balances[_from]);
246         require(_value <= allowed[_from][msg.sender]);
247 
248         balances[_from] = balances[_from].sub(_value);
249         balances[_to] = balances[_to].add(_value);
250         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251         emit Transfer(_from, _to, _value);
252         return true;
253     }
254 
255     //6
256     /**
257      * @dev Function to check the amount of tokens that an owner allowed to a spender.
258      * @param _owner address The address which owns the funds.
259      * @param _spender address The address which will spend the funds.
260      * @return A uint256 specifying the amount of tokens still available for the spender.
261      */
262     function allowance(address _owner, address _spender) public view returns (uint256) {
263         return allowed[_owner][_spender];
264     }
265 
266     //additional functions for altering allowances
267     /**
268      * @dev Increase the amount of tokens that an owner allowed to a spender.
269      *
270      * approve should be called when allowed[_spender] == 0. To increment
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * @param _spender The address which will spend the funds.
275      * @param _addedValue The amount of tokens to increase the allowance by.
276      */
277     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
278         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     /**
284      * @dev Decrease the amount of tokens that an owner allowed to a spender.
285      *
286      * approve should be called when allowed[_spender] == 0. To decrement
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * @param _spender The address which will spend the funds.
291      * @param _subtractedValue The amount of tokens to decrease the allowance by.
292      */
293     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
294         uint oldValue = allowed[msg.sender][_spender];
295         if (_subtractedValue > oldValue) {
296             allowed[msg.sender][_spender] = 0;
297         } else {
298             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299         }
300         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301         return true;
302     }
303 
304               //***ERC20 Events***//
305     //Event 1
306     // Triggered whenever approve(address _spender, uint256 _value) is called.
307     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
308 
309     //Event 2
310     // Triggered when tokens are transferred.
311     event Transfer(address indexed _from, address indexed _to, uint256 _value);
312 
313 }
314 
315 
316 //Using OpenZeppelin Crowdsale contract as a reference and altered, also using ethereum.org/Crowdsale as a reference.
317 /**
318  * @title Crowdsale
319  * @dev Crowdsale is a base contract for managing a token crowdsale.
320  * Crowdsales have a start and end timestamps, where investors can make
321  * token purchases and the crowdsale will assign them tokens based
322  * on a token per ETH rate. Funds collected are forwarded to a wallet
323  * as they arrive.
324 
325  //The original OpenZeppelin contract requires a MintableToken that will be
326  * minted as contributions arrive, note that the crowdsale contract
327  * must be owner of the token in order to be able to mint it.
328  //This version does not use a MintableToken.
329  */
330 contract BitcubCrowdsale is Ownable {
331     using SafeMath for uint256;
332 
333     // The token being sold
334     Bitcub public token;
335 
336     //The amount of the tokens remaining that are unsold.
337     uint256 remainingTokens = 350000000 *(10**18);
338 
339     // start and end timestamps where investments are allowed (inclusive), as well as timestamps for beginning and end of presale tiers
340     uint256 public startTime;
341     uint256 public endTime;
342     uint256 public tier1Start;
343     uint256 public tier1End;
344     uint256 public tier2Start;
345     uint256 public tier2End;
346 
347     // address where funds are collected
348     address public etherWallet;
349     // address where unsold tokens are sent
350     address public tokenWallet;
351 
352     // how many token units a buyer gets per wei
353     uint256 public rate = 100;
354 
355     // amount of raised money in wei
356     uint256 public weiRaised;
357 
358     //minimum purchase for an buyer in amount of ether (1 token)
359     uint256 public minPurchaseInEth = 0.01 ether;
360   
361     //maximum investment for an investor in amount of tokens
362     //To set max investment to 5% of total, it is 25,000,000 tokens, which is 250000 ETH
363     uint256 public maxInvestment = 250000 ether;
364   
365     //mapping to keep track of the amount invested by each address.
366     mapping (address => uint256) internal invested;
367 
368 
369     /**
370     * event for token purchase logging
371     * @param purchaser who paid for the tokens
372     * @param beneficiary who got the tokens
373     * @param value weis paid for purchase
374     * @param amount amount of tokens purchased
375     */
376     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
377 
378     //Constructor for crowdsale.
379     constructor() public {
380         //hard coded times and wallets 
381         startTime = now ;
382         tier1Start = startTime ;
383         tier1End = 1528416000 ; //midnight on 2018-06-08 GMT
384         tier2Start = tier1End;
385         tier2End = 1532131200 ; //midnight on 2018-07-21 GMT
386         endTime = 1538265600 ; //midnight on 2018-09-30 GMT
387         etherWallet = 0xaf0A558783E92a1aEC9dd2D10f2Dc9b9AF371212;
388         tokenWallet = 0xaf0A558783E92a1aEC9dd2D10f2Dc9b9AF371212;
389 
390         require(startTime >= now);
391         require(endTime >= startTime);
392         require(etherWallet != address(0));
393 
394         //establishes ownership of the contract upon creation
395         Ownable(msg.sender);
396 
397         //calls the function to create the token contract itself.
398         token = createTokenContract();
399     }
400 
401     function createTokenContract() internal returns (Bitcub) {
402       // Create Token contract
403       // The amount for sale will be assigned to the crowdsale contract, the reserves will be sent to the Bitcub Wallet
404         return new Bitcub();
405     }
406 
407     // fallback function can be used to buy tokens
408     //This function is called whenever ether is sent to this contract address.
409     function () external payable {
410         //calls the buyTokens function with the address of the sender as the beneficiary address
411         buyTokens(msg.sender);
412     }
413 
414     //This function is called after the ICO has ended to send the unsold Tokens to the specified address
415     function finalizeCrowdsale() public onlyOwner returns (bool) {
416         require(hasEnded());
417         require(token.transfer(tokenWallet, remainingTokens));
418         return true;
419     }
420 
421     // low level token purchase function
422     //implements the logic for the token buying
423     function buyTokens(address beneficiary) public payable {
424         //tokens cannot be burned by sending to 0x0 address
425         require(beneficiary != address(0));
426         //token must adhere to the valid restrictions of the validPurchase() function, ie within time period and buying tokens within max/min limits
427         require(validPurchase(beneficiary));
428 
429         uint256 weiAmount = msg.value;
430 
431         // calculate token amount to be bought
432         uint256 tokens = getTokenAmount(weiAmount);
433 
434         //Logic so that investors must purchase at least 1 token.
435         require(weiAmount >= minPurchaseInEth); 
436 
437         //Token transfer
438         require(token.transfer(beneficiary, tokens));
439 
440         // update state
441         //increment the total ammount raised by the amount of this transaction
442         weiRaised = weiRaised.add(weiAmount);
443         //decrease the amount of remainingTokens by the amount of tokens sold
444         remainingTokens = remainingTokens.sub(tokens);
445         //increase the investment total of the buyer
446         invested[beneficiary] = invested[beneficiary].add(msg.value);
447 
448         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
449 
450         //transfer the ether received to the specified recipient address
451         forwardFunds();
452     }
453 
454     // @return true if crowdsale event has ended
455     function hasEnded() public view returns (bool) {
456         return now > endTime;
457     }
458 
459     // Function to have a way to add business logic to your crowdsale when buying
460     function getTokenAmount(uint256 weiAmount) internal returns(uint256) {
461         //Logic for pricing based on the Tiers of the crowdsale
462         // These bonus amounts and the number of tiers itself can be changed
463         /*This means that:
464             - If you purchase within the tier 1 ICO (earliest tier)
465             you receive a 20% bonus in your token purchase.
466             - If you purchase within the tier 2 ICO (later tier)
467             you receive a 10% bonus in your token purchase.
468             - If you purchase outside of any of the defined bonus tiers then you
469             receive the original rate of tokens (1 token per 0.01 ether)
470             */
471         if (now>=tier1Start && now < tier1End) {
472             rate = 120;
473         }else if (now>=tier2Start && now < tier2End) {
474             rate = 110;
475         }else {
476             rate = 100;
477         }
478 
479         return weiAmount.mul(rate);
480     }
481 
482     // send ether to the fund collection wallet
483     // override to create custom fund forwarding mechanisms
484     function forwardFunds() internal {
485         etherWallet.transfer(msg.value);
486     }
487 
488     // @return true if the transaction can buy tokens
489     function validPurchase(address beneficiary) internal view returns (bool) {
490         bool withinPeriod = now >= startTime && now <= endTime;
491         bool nonZeroPurchase = msg.value != 0;
492         bool withinMaxInvestment = ( invested[beneficiary].add(msg.value) <= maxInvestment );
493 
494         return withinPeriod && nonZeroPurchase && withinMaxInvestment;
495     }
496 
497 }