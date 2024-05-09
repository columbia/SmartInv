1 pragma solidity ^0.4.16;
2 
3   /**
4   * @title SafeMath
5   * @dev Math operations with safety checks that throw on error
6   */
7   library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50     address public owner;
51 
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     emit Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     emit Unpause();
103   }
104 }
105 
106 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
107 
108 contract TokenERC20 is Pausable{
109     // Public variables of the token
110     string public name;
111     string public symbol;
112     uint8 public decimals = 18;
113     // 18 decimals is the strongly suggested default, avoid changing it
114     uint256 public totalSupply;
115     uint256 public totalSupplyForDivision;
116 
117     // This creates an array with all balances
118     mapping (address => uint256) public balanceOf; 
119     mapping (address => mapping (address => uint256)) public allowance;
120 
121     // This generates a public event on the blockchain that will notify clients
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     // This notifies clients about the amount burnt
125     event Burn(address indexed from, uint256 value);
126 
127     /**
128      * Constrctor function
129      *
130      * Initializes contract with initial supply tokens to the creator of the contract
131      */
132     function TokenERC20(
133         uint256 initialSupply,
134         string tokenName,
135         string tokenSymbol
136     ) public {
137         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
138         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
139         name = tokenName;                                   // Set the name for display purposes
140         symbol = tokenSymbol;
141     }
142     
143     /**
144      * Internal transfer, only can be called by this contract
145      */
146     function _transfer(address _from, address _to, uint _value) internal whenNotPaused{
147         // Prevent transfer to 0x0 address. Use burn() instead
148         require(_to != 0x0);
149         // Check if the sender has enough
150         require(balanceOf[_from] >= _value);
151         // Check for overflows
152         require(balanceOf[_to] + _value > balanceOf[_to]);
153         // Save this for an assertion in the future
154         uint previousBalances = balanceOf[_from] + balanceOf[_to];
155         // Subtract from the sender
156         balanceOf[_from] -= _value;
157         // Add the same to the recipient
158         balanceOf[_to] += _value;
159         emit Transfer(_from, _to, _value);
160         // Asserts are used to use static analysis to find bugs in your code. They should never fail
161         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
162     }
163 
164     /**
165      * Transfer tokens
166      *
167      * Send `_value` tokens to `_to` from your account
168      *
169      * @param _to The address of the recipient
170      * @param _value the amount to send
171      */
172     function transfer(address _to, uint256 _value) public whenNotPaused {
173         _transfer(msg.sender, _to, _value);
174     }
175 
176     /**
177      * Transfer tokens from other address
178      *
179      * Send `_value` tokens to `_to` in behalf of `_from`
180      *
181      * @param _from The address of the sender
182      * @param _to The address of the recipient
183      * @param _value the amount to send
184      */
185     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
186         require(_value <= allowance[_from][msg.sender]);     // Check allowance
187         allowance[_from][msg.sender] -= _value;
188         _transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193      * Set allowance for other address
194      *
195      * Allows `_spender` to spend no more than `_value` tokens in your behalf
196      *
197      * @param _spender The address authorized to spend
198      * @param _value the max amount they can spend
199      */
200     function approve(address _spender, uint256 _value) public whenNotPaused
201         returns (bool success) {
202         allowance[msg.sender][_spender] = _value;
203         return true;
204     }
205 
206     /**
207      * Set allowance for other address and notify
208      *
209      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
210      *
211      * @param _spender The address authorized to spend
212      * @param _value the max amount they can spend
213      * @param _extraData some extra information to send to the approved contract
214      */
215     function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused
216         public
217         returns (bool success) {
218         tokenRecipient spender = tokenRecipient(_spender);
219         if (approve(_spender, _value)) {
220             spender.receiveApproval(msg.sender, _value, this, _extraData);
221             return true;
222         }
223     }
224 
225     /**
226      * Destroy tokens
227      *
228      * Remove `_value` tokens from the system irreversibly
229      *
230      * @param _value the amount of money to burn
231      */
232     function burn(uint256 _value) public whenPaused returns (bool success) {
233         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
234         balanceOf[msg.sender] -= _value;            // Subtract from the sender
235         totalSupply -= _value;                      // Updates totalSupply
236         totalSupplyForDivision -= _value;                              // Update totalSupply
237         emit Burn(msg.sender, _value);
238         return true;
239     }
240 
241     /**
242      * Destroy tokens from other account
243      *
244      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
245      *
246      * @param _from the address of the sender
247      * @param _value the amount of money to burn
248      */
249     function burnFrom(address _from, uint256 _value) public whenPaused returns (bool success) {
250         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
251         require(_value <= allowance[_from][msg.sender]);    // Check allowance
252         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
253         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
254         totalSupply -= _value;                              // Update totalSupply
255         totalSupplyForDivision -= _value;                              // Update totalSupply
256         emit Burn(_from, _value);
257         return true;
258     }
259 }
260 
261 /******************************************/
262 /*       ADVANCED TOKEN STARTS HERE       */
263 /******************************************/
264 
265 contract DunkPayToken is TokenERC20 {
266 
267     uint256 public sellPrice;
268     uint256 public buyPrice;
269     uint256 public buySupply;
270     uint256 public totalEth;
271     mapping (address => bool) public frozenAccount;
272 
273     /* This generates a public event on the blockchain that will notify clients */
274     event FrozenFunds(address target, bool frozen);
275 
276     /* Initializes contract with initial supply tokens to the creator of the contract */
277     function DunkPayToken() TokenERC20(totalSupply, name, symbol) public {
278 
279         buyPrice = 1000;
280         sellPrice = 1000;
281         
282         name = "BitcoinYo Token";
283         symbol = "BTY";
284         totalSupply = buyPrice * 10000 * 10 ** uint256(decimals);
285         balanceOf[msg.sender] = buyPrice * 5100 * 10 ** uint256(decimals);              
286         balanceOf[this] = totalSupply - balanceOf[msg.sender];
287         buySupply = balanceOf[this];
288         totalSupplyForDivision = totalSupply;// Set the symbol for display purposes
289         totalEth = address(this).balance;
290     }
291 
292     function percent(uint256 numerator, uint256 denominator , uint precision) returns(uint256 quotient) {
293         if(numerator <= 0)
294         {
295             return 0;
296         }
297         // caution, check safe-to-multiply here
298         uint256 _numerator  = numerator * 10 ** uint256(precision+1);
299         // with rounding of last digit
300         uint256 _quotient =  ((_numerator / denominator) - 5) / 10;
301         return  _quotient;
302     }
303     
304     function getZero(uint256 number) returns(uint num_len) {
305         uint i = 1;
306         uint _num_len = 0;
307         while( number > i )
308         {
309             i *= 10;
310             _num_len++;
311         }
312         return _num_len;
313     }
314 
315     /* Internal transfer, only can be called by this contract */
316     function _transfer(address _from, address _to, uint _value) internal {
317         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
318         require (balanceOf[_from] >= _value);               // Check if the sender has enough
319         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
320         require(!frozenAccount[_from]);                     // Check if sender is frozen
321         require(!frozenAccount[_to]);                       // Check if recipient is frozen
322         balanceOf[_from] -= _value;                         // Subtract from the sender
323         balanceOf[_to] += _value;                           // Add the same to the recipient
324         emit Transfer(_from, _to, _value);
325     }
326 
327     /// @notice Create `mintedAmount` tokens and send it to `target`
328     /// @param target Address to receive the tokens
329     /// @param mintedAmount the amount of tokens it will receive
330     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
331         balanceOf[target] += mintedAmount;
332         totalSupply += mintedAmount;
333         totalSupplyForDivision += mintedAmount;
334         emit Transfer(0, this, mintedAmount);
335         emit Transfer(this, target, mintedAmount);
336     }
337 
338     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
339     /// @param target Address to be frozen
340     /// @param freeze either to freeze it or not
341     function freezeAccount(address target, bool freeze) onlyOwner public {
342         frozenAccount[target] = freeze;
343         emit FrozenFunds(target, freeze);
344     }
345 
346     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
347     /// @param newSellPrice Price the users can sell to the contract
348     /// @param newBuyPrice Price users can buy from the contract
349     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
350         sellPrice = newSellPrice;
351         buyPrice = newBuyPrice;
352         
353     }
354 
355     function transfer(address _to, uint256 _value) public whenNotPaused {
356         if(_to == address(this)){
357             sell(_value);
358         }else{
359             _transfer(msg.sender, _to, _value);
360         }
361     }
362 
363     function () payable public {
364      buy();
365     }
366 
367     /// @notice Buy tokens from contract by sending ether
368     function buy() payable whenNotPaused public {
369         uint256 dnkForBuy = msg.value;
370         uint zeros = getZero(buySupply);
371         uint256 interest = msg.value / 2 * percent(balanceOf[this] , buySupply , zeros);
372         interest = interest / 10 ** uint256(zeros);
373         dnkForBuy = dnkForBuy + interest;
374         _transfer(this, msg.sender, dnkForBuy * buyPrice);              // makes the transfers
375         totalEth += msg.value;
376     }
377 
378     /// @notice Sell `amount` tokens to contract
379     /// @param amount amount of tokens to be sold
380     function sell(uint256 amount) whenNotPaused public {
381         uint256 ethForSell =  amount;
382         uint zeros = getZero(balanceOf[this]);
383         uint256 interest = amount / 2 * percent( buySupply , balanceOf[this] ,zeros);
384         interest = interest / 10 ** uint256(zeros);
385         ethForSell = ethForSell - interest;
386         ethForSell = ethForSell - (ethForSell/100); // minus 1% for refund fee.   
387         ethForSell = ethForSell / sellPrice;
388         uint256 minimumAmount = address(this).balance; 
389         require(minimumAmount >= ethForSell);      // checks if the contract has enough ether to buy
390         _transfer(msg.sender, this, amount);              // makes the transfers
391         msg.sender.transfer(ethForSell);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
392         totalEth -= ethForSell;
393     } 
394 
395     /// @notice withDraw `amount` ETH to contract
396     /// @param amount amount of ETH to be sent
397     function withdraw(uint256 amount) onlyOwner public {
398         uint256 minimumAmount = address(this).balance; 
399         require(minimumAmount >= amount);      // checks if the contract has enough ether to buy
400         msg.sender.transfer(amount);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
401     }
402 
403     function airdrop(address[] _holders, uint256 mintedAmount) onlyOwner whenPaused public {
404         for (uint i = 0; i < _holders.length; i++) {
405             uint zeros = getZero(totalSupplyForDivision);
406             uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision,zeros)  * mintedAmount;
407             amount = amount / 10 ** uint256(zeros);
408             if(amount != 0){
409                 mintToken(_holders[i], amount);
410             }
411         }
412         totalSupplyForDivision = totalSupply;
413     }
414 
415     function bankrupt(address[] _holders) onlyOwner whenPaused public {
416         uint256 restBalance = balanceOf[this];
417         balanceOf[this] -= restBalance;                        // Subtract from the targeted balance
418         totalSupply -= restBalance;                              // Update totalSupply
419         totalSupplyForDivision -= restBalance;                             // Update totalSupply
420         totalEth = address(this).balance;
421         
422         for (uint i = 0; i < _holders.length; i++) {
423           uint zeros = getZero(totalSupplyForDivision);
424           uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision , zeros) * totalEth;
425           amount = amount / 10 ** uint256(zeros);
426         
427           if(amount != 0){
428             uint256 minimumAmount = address(this).balance; 
429             require(minimumAmount >= amount);      // checks if the contract has enough ether to buy
430             uint256 holderBalance = balanceOf[_holders[i]];
431             balanceOf[_holders[i]] -= holderBalance;                        // Subtract from the targeted balance
432             totalSupply -= holderBalance;            
433             _holders[i].transfer(amount);          // sends ether to the seller. It's important to do this last to 
434           } 
435         }
436         totalSupplyForDivision = totalSupply;
437         totalEth = address(this).balance;
438     }    
439 }