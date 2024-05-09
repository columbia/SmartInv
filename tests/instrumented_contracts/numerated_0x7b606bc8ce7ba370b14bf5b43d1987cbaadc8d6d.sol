1 pragma solidity ^0.4.16;
2 
3   /**
4   * @title SafeMath
5   * @dev Math operations with safety checks that throw on error
6   */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract Ownable {
54     address public owner;
55 
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public {
66         owner = newOwner;
67     }
68 }
69 
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
111 
112 contract TokenERC20 is Pausable{
113     
114     using SafeMath for uint256;    
115     
116     // Public variables of the token
117     string public name;
118     string public symbol;
119     uint8 public decimals = 18;
120     // 18 decimals is the strongly suggested default, avoid changing it
121     uint256 public totalSupply;
122     uint256 totalSupplyForDivision;
123 
124     // This creates an array with all balances
125     mapping (address => uint256) public balanceOf; 
126     mapping (address => mapping (address => uint256)) public allowance;
127 
128     // This generates a public event on the blockchain that will notify clients
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     // This notifies clients about the amount burnt
132     event Burn(address indexed from, uint256 value);
133 
134     /**
135      * Constrctor function
136      *
137      * Initializes contract with initial supply tokens to the creator of the contract
138      */
139     function TokenERC20(
140         uint256 initialSupply,
141         string tokenName,
142         string tokenSymbol
143     ) public {
144         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
145         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
146         name = tokenName;                                   // Set the name for display purposes
147         symbol = tokenSymbol;
148     }
149     
150     /**
151      * Internal transfer, only can be called by this contract
152      */
153     function _transfer(address _from, address _to, uint _value) internal whenNotPaused{
154         // Prevent transfer to 0x0 address. Use burn() instead
155         require(_to != 0x0);
156         // Check if the sender has enough
157         require(balanceOf[_from] >= _value);
158         // Check for overflows
159         require(balanceOf[_to].add(_value) > balanceOf[_to]);
160         // Save this for an assertion in the future
161         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
162         // Subtract from the sender
163         balanceOf[_from] = balanceOf[_from].sub(_value);
164         // Add the same to the recipient
165         balanceOf[_to] = balanceOf[_to].add(_value);
166         emit Transfer(_from, _to, _value);
167         // Asserts are used to use static analysis to find bugs in your code. They should never fail
168         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
169     }
170 
171     /**
172      * Transfer tokens
173      *
174      * Send `_value` tokens to `_to` from your account
175      *
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transfer(address _to, uint256 _value) public whenNotPaused {
180         _transfer(msg.sender, _to, _value);
181     }
182 
183     /**
184      * Transfer tokens from other address
185      *
186      * Send `_value` tokens to `_to` in behalf of `_from`
187      *
188      * @param _from The address of the sender
189      * @param _to The address of the recipient
190      * @param _value the amount to send
191      */
192     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
193         require(_value <= allowance[_from][msg.sender]);     // Check allowance
194         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
195         _transfer(_from, _to, _value);
196         return true;
197     }
198 
199     /**
200      * Set allowance for other address
201      *
202      * Allows `_spender` to spend no more than `_value` tokens in your behalf
203      *
204      * @param _spender The address authorized to spend
205      * @param _value the max amount they can spend
206      */
207     function approve(address _spender, uint256 _value) public whenNotPaused
208         returns (bool success) {
209         allowance[msg.sender][_spender] = _value;
210         return true;
211     }
212 
213     /**
214      * Set allowance for other address and notify
215      *
216      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
217      *
218      * @param _spender The address authorized to spend
219      * @param _value the max amount they can spend
220      * @param _extraData some extra information to send to the approved contract
221      */
222     function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused
223         public
224         returns (bool success) {
225         tokenRecipient spender = tokenRecipient(_spender);
226         if (approve(_spender, _value)) {
227             spender.receiveApproval(msg.sender, _value, this, _extraData);
228             return true;
229         }
230     }
231 
232     /**
233      * Destroy tokens
234      *
235      * Remove `_value` tokens from the system irreversibly
236      *
237      * @param _value the amount of money to burn
238      */
239     function burn(uint256 _value) public whenPaused returns (bool success) {
240         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
241         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
242         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
243         totalSupplyForDivision = totalSupply;                              // Update totalSupply
244         emit Burn(msg.sender, _value);
245         return true;
246     }
247     /**
248      * Destroy tokens from other account
249      *
250      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
251      *
252      * @param _from the address of the sender
253      * @param _value the amount of money to burn
254      */
255     function burnFrom(address _from, uint256 _value) public whenPaused returns (bool success) {
256         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
257         require(_value <= allowance[_from][msg.sender]);    // Check allowance
258         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
259         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
260         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
261         totalSupplyForDivision = totalSupply;                              // Update totalSupply
262         emit Burn(_from, _value);
263         return true;
264     }
265 }
266 
267 /******************************************/
268 /*       ADVANCED TOKEN STARTS HERE       */
269 /******************************************/
270 
271 contract DunkPayToken is TokenERC20 {
272 
273     uint256 public sellPrice;
274     uint256 public buyPrice;
275     uint256 public buySupply;
276     uint256 public totalEth;
277     uint256 minimumAmountForPos;
278     mapping (address => bool) public frozenAccount;
279 
280     /* This generates a public event on the blockchain that will notify clients */
281     event FrozenFunds(address target, bool frozen);
282 
283     /* Initializes contract with initial supply tokens to the creator of the contract */
284     function DunkPayToken() TokenERC20(totalSupply, name, symbol) public {
285 
286         buyPrice = 1000;
287         sellPrice = 1000;
288         
289         name = "DunkPay";
290         symbol = "DNK";
291         totalSupply = buyPrice * 10000 * 10 ** uint256(decimals);
292         minimumAmountForPos = buyPrice * 1 * 10 ** uint256(decimals);
293         balanceOf[msg.sender] = buyPrice * 5100 * 10 ** uint256(decimals);              
294         balanceOf[this] = totalSupply - balanceOf[msg.sender];
295         buySupply = balanceOf[this];
296         allowance[this][msg.sender] = buySupply;
297         totalSupplyForDivision = totalSupply;// Set the symbol for display purposes
298         totalEth = address(this).balance;
299         
300     }
301 
302     function percent(uint256 numerator, uint256 denominator , uint precision) returns(uint256 quotient) {
303         if(numerator <= 0)
304         {
305             return 0;
306         }
307         // caution, check safe-to-multiply here
308         uint256 _numerator  = numerator.mul(10 ** uint256(precision+1));
309         // with rounding of last digit
310         uint256 _quotient =  ((_numerator.div(denominator)).sub(5)).div(10);
311         return  _quotient;
312     }
313     
314     function getZero(uint256 number) returns(uint num_len) {
315         uint i = 1;
316         uint _num_len = 0;
317         while( number > i )
318         {
319             i *= 10;
320             _num_len++;
321         }
322         return _num_len;
323     }
324 
325     /* Internal transfer, only can be called by this contract */
326     function _transfer(address _from, address _to, uint _value) internal {
327         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
328         require (balanceOf[_from] >= _value);               // Check if the sender has enough
329         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
330         require(!frozenAccount[_from]);                     // Check if sender is frozen
331         require(!frozenAccount[_to]);                       // Check if recipient is frozen
332         balanceOf[_from] -= _value;                         // Subtract from the sender
333         balanceOf[_to] += _value;                           // Add the same to the recipient
334         emit Transfer(_from, _to, _value);
335     }
336 
337     /// @notice Create `mintedAmount` tokens and send it to `target`
338     /// @param target Address to receive the tokens
339     /// @param mintedAmount the amount of tokens it will receive
340     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
341         balanceOf[target] += mintedAmount;
342         totalSupply += mintedAmount;
343         emit Transfer(0, this, mintedAmount);
344         emit Transfer(this, target, mintedAmount);
345     }
346     
347     function AddSupply(uint256 mintedAmount) onlyOwner public {
348         buySupply += mintedAmount; 
349         allowance[this][msg.sender] += mintedAmount;
350         mintToken(address(this), mintedAmount);
351     }
352     
353     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
354     /// @param target Address to be frozen
355     /// @param freeze either to freeze it or not
356     function freezeAccount(address target, bool freeze) onlyOwner public {
357         frozenAccount[target] = freeze;
358         emit FrozenFunds(target, freeze);
359     }
360 
361     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
362     /// @param newSellPrice Price the users can sell to the contract
363     /// @param newBuyPrice Price users can buy from the contract
364     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
365         sellPrice = newSellPrice;
366         buyPrice = newBuyPrice;
367     }
368 
369     function transfer(address _to, uint256 _value) public whenNotPaused {
370         if(_to == address(this)){
371             sell(_value);
372         }else{
373             _transfer(msg.sender, _to, _value);
374         }
375     }
376 
377     function () payable public {
378         buy();
379     }
380 
381     /// @notice Buy tokens from contract by sending ether
382     function buy() payable whenNotPaused public {
383         uint256 dnkForBuy = msg.value;
384         uint zeros = getZero(totalSupply);
385         uint256 interest = (dnkForBuy.div(2)).mul(percent(balanceOf[this], totalSupply , zeros));
386         interest = interest.div(10 ** uint256(zeros));
387         dnkForBuy = dnkForBuy.add(interest);
388         require(dnkForBuy > 0);  
389         _transfer(this, msg.sender, dnkForBuy.mul(buyPrice));              // makes the transfers
390         totalEth = totalEth.add(msg.value);
391     }
392 
393     /// @notice Sell `amount` tokens to contract
394     /// @param amount amount of tokens to be sold
395     function sell(uint256 amount) whenNotPaused public {
396         uint256 ethForSell =  amount;
397         uint zeros = getZero(totalSupply);
398         uint256 interest = (ethForSell.div(2)).mul(percent(balanceOf[this], totalSupply , zeros));
399         interest = interest.div(10 ** uint256(zeros));
400         ethForSell = ethForSell.div(2) + interest;
401         ethForSell = ethForSell.sub(ethForSell.div(100)); // minus 1% for refund fee.   
402         ethForSell = ethForSell.div(sellPrice);
403         require(ethForSell > 0);  
404         uint256 minimumAmount = address(this).balance; 
405         require(minimumAmount >= ethForSell);      // checks if the contract has enough ether to buy
406         _transfer(msg.sender, this, amount);              // makes the transfers
407         msg.sender.transfer(ethForSell);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
408         totalEth = totalEth.sub(ethForSell);
409     }
410     
411     /// @notice withDraw `amount` ETH to contract
412     /// @param amount amount of ETH to be sent
413     function withdraw(uint256 amount) onlyOwner public {
414         uint256 minimumAmount = address(this).balance; 
415         require(minimumAmount >= amount);      // checks if the contract has enough ether to buy
416         msg.sender.transfer(amount);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
417         totalEth = totalEth.sub(amount);
418     }
419 
420     function pos(address[] _holders, uint256 mintedAmount) onlyOwner whenPaused public {
421         for (uint i = 0; i < _holders.length; i++) {
422             uint zeros = getZero(totalSupplyForDivision);
423             uint256 holderBalance = balanceOf[_holders[i]];
424             if(holderBalance>minimumAmountForPos)
425             {
426                 uint256 amount = percent(holderBalance,totalSupplyForDivision,zeros).mul(mintedAmount);
427                 amount = amount.div(10 ** uint256(zeros));
428                 if(amount > 0){
429                     mintToken(_holders[i], amount);
430                 }
431             }
432         }
433         totalSupplyForDivision = totalSupply;
434     }
435 
436     function bankrupt(address[] _holders) onlyOwner whenPaused public {
437         uint256 restBalance = balanceOf[this];
438         totalSupplyForDivision = totalSupply.sub(restBalance);                             
439         totalEth = address(this).balance;
440         for (uint i = 0; i < _holders.length; i++) {
441           uint zeros = getZero(totalSupplyForDivision);
442           uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision , zeros).mul(totalEth);
443           amount = amount.div(10 ** uint256(zeros));
444           if(amount > 0){
445             uint256 minimumAmount = address(this).balance; 
446             require(minimumAmount >= amount);      // checks if the contract has enough ether to buy
447             uint256 holderBalance = balanceOf[_holders[i]];
448             balanceOf[_holders[i]] = balanceOf[_holders[i]].sub(holderBalance);                        // Subtract from the targeted balance
449             totalSupply = totalSupply.sub(holderBalance);            
450             _holders[i].transfer(amount);          // sends ether to the seller. It's important to do this last to 
451           } 
452         }
453         totalSupplyForDivision = totalSupply;
454         totalEth = address(this).balance;
455     }    
456 }