1 pragma solidity ^0.4.11;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol,
49         uint8 decimalPalces
50     ) public {
51         totalSupply = initialSupply * 10 ** uint256(decimalPalces);  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55         decimals = decimalPalces;
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);        
64         require(balanceOf[_from] >= _value);        
65         require(balanceOf[_to] + _value > balanceOf[_to]);        
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];        
67         balanceOf[_from] -= _value;        
68         balanceOf[_to] += _value;
69         Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      * Send `_value` tokens to `_to` from your account     
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /**
85      * Transfer tokens from other address
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
118     {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 
126     /**
127      * Destroy tokens
128      * Remove `_value` tokens from the system irreversibly
129      * @param _value the amount of money to burn
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
133         balanceOf[msg.sender] -= _value;            // Subtract from the sender
134         totalSupply -= _value;                      // Updates totalSupply
135         Burn(msg.sender, _value);
136         return true;
137     }
138 
139     /**
140      * Destroy tokens from other account
141      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
142      * @param _from the address of the sender
143      * @param _value the amount of money to burn
144      */
145     function burnFrom(address _from, uint256 _value) public returns (bool success) {
146         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
147         require(_value <= allowance[_from][msg.sender]);    // Check allowance
148         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
149         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
150         totalSupply -= _value;                              // Update totalSupply
151         Burn(_from, _value);
152         return true;
153     }
154 }
155 
156 /******************************************/
157 /*     UTILITY FUNCTIONS STARTS HERE      */
158 /******************************************/
159 
160 contract utility
161 {
162     event check1(uint256 val1);
163     function calculateEthers(uint numberOfTokens, uint price, uint _decimalValue) constant internal returns(uint ethers)
164     {
165         ethers = numberOfTokens*price;
166         ethers = ethers / 10**_decimalValue;
167         check1(ethers);
168         return (ethers);
169     }
170     
171     function calculateTokens(uint _amount, uint _rate, uint _decimalValue) constant internal returns(uint tokens, uint excessEthers) 
172     {
173         tokens = _amount*10**_decimalValue;
174         tokens = tokens/_rate;
175         excessEthers = _amount-((tokens*_rate)/10**_decimalValue);
176         return (tokens, excessEthers);
177     } 
178     
179    
180     function decimalAdjustment(uint _amount, uint _decimalPlaces) constant internal returns(uint adjustedValue)
181     {
182         uint diff = 18-_decimalPlaces;
183         uint adjust = 1*10**diff;
184        
185         adjustedValue = _amount/adjust;
186        
187         return adjustedValue;       
188     }
189    
190     // function ceil(uint a, uint m) constant returns (uint ) {
191     //     return ((a + m - 1) / m) * m;
192     // }
193 }
194 
195 /******************************************/
196 /*       ADVANCED TOKEN STARTS HERE       */
197 /******************************************/
198 
199 contract TokenNWTC is owned, TokenERC20, utility {
200     
201     event check(uint256 val1);
202     
203     uint256 public sellPrice;
204     uint256 public buyPrice;
205     address[] frzAcc;
206     address[] users;
207     address[] frzAcc1;
208     address[] users1;
209     uint256 sellTokenAmount;
210 
211     bool emergencyFreeze;       // If this variable is true then all account will be frozen and can not transfer/recieve tokens.
212 
213     mapping (address => bool) public frozenAccount;
214     mapping (uint => address) public tokenUsers;
215 
216     /* This generates a public event on the blockchain that will notify clients */
217     event FrozenFunds(address target, bool frozen);
218 
219     /* Initializes contract with initial supply tokens to the creator of the contract */
220     function TokenNWTC(
221         uint256 initialSupply,
222         string tokenName,
223         string tokenSymbol,
224         uint8 decimalPalces
225     ) TokenERC20(initialSupply, tokenName, tokenSymbol, decimalPalces) public {}
226 
227     /* Internal transfer, only can be called by this contract */
228     function _transfer(address _from, address _to, uint _value) internal {
229         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
230         require (balanceOf[_from] >= _value);                // Check if the sender has enough
231         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
232         require(!frozenAccount[_from]);                     // Check if sender is frozen
233         require(!frozenAccount[_to]);                       // Check if recipient is frozen
234         require(!emergencyFreeze);                          // Check if emergencyFreeze enable  // by JD.
235         balanceOf[_from] -= _value;                         // Subtract from the sender
236         balanceOf[_to] += _value;                           // Add the same to the recipient
237         Transfer(_from, _to, _value);
238         sellTokenAmount += _value;
239         
240         if (users.length>0){
241                 uint count=0;
242             for (uint a=0;a<users.length;a++)
243             {
244             if (users[a]==_to){
245             count=count+1;
246             }
247             }
248             if (count==0){
249                 users.push(_to);
250             }
251                  
252         }
253         else{
254             users.push(_to);
255         }
256     }
257     
258 
259     // @notice Create `mintedAmount` tokens and send it to `target`
260     // @param target Address to receive the tokens
261     // @param mintedAmount the amount of tokens it will receive
262     // amount should be in form of decimal specified in this contract.
263     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
264         //require(target!=0x0);
265         balanceOf[target] += mintedAmount;
266         totalSupply += mintedAmount;
267         Transfer(0, this, mintedAmount);
268         Transfer(this, target, mintedAmount);
269         sellTokenAmount += mintedAmount;
270         
271          if (users.length>0){
272                 uint count1=0;
273             for (uint a=0;a<users.length;a++)
274             {
275             if (users[a]==target){
276             count1=count1+1;
277             }
278             }
279             if (count1==0){
280                 users.push(target);
281             }
282                  
283         }
284         else{
285             users.push(target);
286         }
287     }
288 
289     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
290     /// @param target Address to be frozen
291     /// @param freeze either to freeze it or not
292     function freezeAccount(address target, bool freeze) onlyOwner public {
293         //require(target!=0x0);
294         frozenAccount[target] = freeze;
295         FrozenFunds(target, freeze);
296         if (frzAcc.length>0){
297                 uint count=0;
298             for (uint a=0;a<frzAcc.length;a++)
299             {
300             if (frzAcc[a]==target){
301             count=count+1;
302             }
303             }
304             if (count==0){
305                 frzAcc.push(target);
306             }
307         }
308         else{
309             frzAcc.push(target);
310         }
311     }
312 
313     function freezeAllAccountInEmergency(bool freezeAll) onlyOwner public
314     {
315         emergencyFreeze = freezeAll;    
316     }
317 
318     /// notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
319     /// @param newSellPrice Price the users can sell to the contract
320     /// @param newBuyPrice Price users can buy from the contract
321     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
322         require(newSellPrice!=0 || sellPrice!=0);
323         require(newBuyPrice!=0 || buyPrice!=0); 
324         if(newSellPrice!=0)
325         {
326             sellPrice = newSellPrice;
327         }
328         if(newBuyPrice!=0)
329         {
330             buyPrice = newBuyPrice;
331         }
332     }
333 
334     /// @notice Buy tokens from contract by sending ether
335     function buy() payable public {
336         require(msg.value!=0);
337         require(buyPrice!=0);
338         uint exceededEthers;
339         uint amount = msg.value;                                // msg.value will be in wei.   
340         (amount, exceededEthers) = calculateTokens(amount, buyPrice, decimals);
341         require(amount!=0);
342         _transfer(this, msg.sender, amount);              // makes the transfers.
343         msg.sender.transfer(exceededEthers);// sends exceeded ether to the seller.
344         
345        // addUsers(msg.sender);
346         
347         if (users.length>0){
348                 uint count=0;
349             for (uint a=0;a<users.length;a++)
350             {
351             if (users[a]==msg.sender){
352             count=count+1;
353             }
354             }
355             if (count==0){
356                 users.push(msg.sender);
357             }
358                  
359         }
360         else{
361             users.push(msg.sender);
362         }
363         
364         
365     }
366 
367     // @notice Sell `amount` tokens to contract
368     // @param amount amount of tokens to be sold
369     // amount should be in form of decimal specified in this contract. 
370     function sell(uint256 amount) public {
371         require(amount!=0);
372         require(sellPrice!=0);
373         uint etherAmount;
374         etherAmount = calculateEthers(amount, sellPrice, decimals);
375         require(this.balance >= etherAmount);           // checks if the contract has enough ether to buy
376         _transfer(msg.sender, this, amount);     // makes the transfers
377         check(etherAmount);
378         msg.sender.transfer(etherAmount);               // sends ether to the seller. It's important to do this last to avoid recursion attacks
379     }
380 
381 
382     function readAllUsers()constant returns(address[]){
383 	      
384 	      
385 	          for (uint k=0;k<users.length;k++){
386 	              if (balanceOf[users[k]]>0){
387 	                  users1.push(users[k]);
388 	              }
389 	          }
390 	      
391        return users1;
392    }
393    
394    function readAllFrzAcc()constant returns(address[]){
395        for (uint k=0;k<frzAcc.length;k++){
396 	              if (frozenAccount[frzAcc[k]] == true){
397 	                  frzAcc1.push(frzAcc[k]);
398 	              }
399 	          }
400        return frzAcc1;
401    }
402    
403    function readSellTokenAmount()constant returns(uint256){
404        return sellTokenAmount;
405    }
406    
407    
408 //   function addUsers(address add) internal{
409 //       uint totalUsers = totalUsers+1;
410 //       tokenUsers[totalUsers] = add;
411 //   }
412    
413 //     function transfer1(address _to, uint256 _value){
414 
415 // 		// if(frozenAccount[msg.sender]) throw;
416 // 		                     // Check if sender is frozen
417 //         require(!frozenAccount[_to]);                       // Check if recipient is frozen
418 //         require(!emergencyFreeze); 
419 // 		require(!frozenAccount[msg.sender]);
420 // 		// if(balanceOf[msg.sender] < _value) throw;
421 // 		require(balanceOf[msg.sender] >= _value);
422 // 		// if(balanceOf[_to] + _value < balanceOf[_to]) throw;
423 // 		require(balanceOf[_to] + _value >= balanceOf[_to]);
424 // 		//if(admin)
425 
426 // 		balanceOf[msg.sender] -= _value;
427 // 		balanceOf[_to] += _value;
428 // 		Transfer(msg.sender, _to, _value);
429 // 	}
430 
431 // 	function transferFrom1(address _from, address _to, uint256 _value) returns (bool success){
432 // 		// if(frozenAccount[_from]) throw;
433 // 		require(!frozenAccount[_from]);
434 // 		// if(balanceOf[_from] < _value) throw;
435 // 		require(balanceOf[_from] >= _value);
436 // 		// if(balanceOf[_to] + _value < balanceOf[_to]) throw;
437 // 		require(balanceOf[_to] + _value >= balanceOf[_to]);
438 // 		// if(_value > allowance[_from][msg.sender]) throw;
439 // 		require(_value <= allowance[_from][msg.sender]);
440 // 		balanceOf[_from] -= _value;
441 // 		balanceOf[_to] += _value;
442 // 		allowance[_from][msg.sender] -= _value;
443 // 		Transfer(_from, _to, _value);
444 // 		return true;
445 
446 // 	}
447 
448     /**
449      * Set allowance for other address
450      * Allows `_spender` to spend no more than `_value` tokens in your behalf
451      * @param _spender The address authorized to spend
452      * @param _value the max amount they can spend
453      */
454     function approve(address _spender, uint256 _value) public
455         returns (bool success) {
456         allowance[msg.sender][_spender] = _value;
457         return true;
458     }
459 
460     /**
461      * Set allowance for other address and notify
462      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
463      * @param _spender The address authorized to spend
464      * @param _value the max amount they can spend
465      * @param _extraData some extra information to send to the approved contract
466      */
467     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
468     {
469         tokenRecipient spender = tokenRecipient(_spender);
470         if (approve(_spender, _value)) {
471             spender.receiveApproval(msg.sender, _value, this, _extraData);
472             return true;
473         }
474     }
475 
476     /**
477      * Destroy tokens
478      * Remove `_value` tokens from the system irreversibly
479      * @param _value the amount of money to burn
480      */
481     function burn(uint256 _value) public returns (bool success) {
482         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
483         balanceOf[msg.sender] -= _value;            // Subtract from the sender
484         totalSupply -= _value;                      // Updates totalSupply
485         Burn(msg.sender, _value);
486         return true;
487     }
488 
489     /**
490      * Destroy tokens from other account
491      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
492      * @param _from the address of the sender
493      * @param _value the amount of money to burn
494      */
495     function burnFrom(address _from, uint256 _value) public returns (bool success) {
496         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
497         require(_value <= allowance[_from][msg.sender]);    // Check allowance
498         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
499         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
500         totalSupply -= _value;                              // Update totalSupply
501         Burn(_from, _value);
502         return true;
503     }
504     
505     //======================================================
506     function getTokenName() constant public returns (string)
507     {
508         return name;
509     }
510     
511     //========================================================
512     function getTokenSymbol() constant public returns (string)
513     {
514         return symbol;
515     }
516 
517     //===========================================================
518     function getSpecifiedDecimal() constant public returns (uint)
519     {
520         return decimals;
521     }
522 
523     //======================================================
524     function getTotalSupply() constant public returns (uint)
525     {
526         return totalSupply;
527     }
528     
529 }