1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'Gas Fund' token contract, having Crowdsale and Investment functionality
4 //
5 // Contract Owner : 0x956881bc9Fbef7a2D176bfB371Be9Ab3e66683fD
6 // Symbol      	  : GAF
7 // Name           : Gas Fund
8 // Total supply   : 50,000,000,000
9 // Decimals       : 18
10 //
11 // Copyright © 2018 onwards Gas Fund Inc. (https://gas-fund.com)
12 // Contract designed by GDO Infotech Pvt Ltd (www.GDO.co.in)
13 // ----------------------------------------------------------------------------
14     
15     /**
16      * @title SafeMath
17      * @dev Math operations with safety checks that throw on error
18      */
19     library SafeMath {
20       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22           return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27       }
28     
29       function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34       }
35     
36       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39       }
40     
41       function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45       }
46     }
47     
48     contract owned {
49         address public owner;
50     	using SafeMath for uint256;
51     	
52          constructor () public {
53             owner = msg.sender;
54         }
55     
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60     
61         function transferOwnership(address newOwner) onlyOwner public {
62             owner = newOwner;
63         }
64     }
65     
66     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
67     
68     contract TokenERC20 {
69         // Public variables of the token
70         using SafeMath for uint256;
71     	string public name;
72         string public symbol;
73         uint8 public decimals = 18;
74         // 18 decimals is the strongly suggested default, avoid changing it
75         uint256 public totalSupply;
76     
77         // This creates an array with all balances
78         mapping (address => uint256) public balanceOf;
79         mapping (address => mapping (address => uint256)) public allowance;
80     
81         // This generates a public event on the blockchain that will notify clients
82         event Transfer(address indexed from, address indexed to, uint256 value);
83     
84         // This notifies clients about the amount burnt
85         event Burn(address indexed from, uint256 value);
86     
87         /**
88          * Constrctor function
89          *
90          * Initializes contract with initial supply tokens to the creator of the contract
91          */
92         constructor (
93             uint256 initialSupply,
94             string tokenName,
95             string tokenSymbol
96         ) public {
97             totalSupply = initialSupply.mul(1 ether);           // Update total supply with the decimal amount
98             uint256 ownerTokens = 8000000;
99             balanceOf[msg.sender] = ownerTokens.mul(1 ether);   // Give the creator 8,000,000 tokens
100             balanceOf[this]=totalSupply.sub(ownerTokens.mul(1 ether));// Remaining tokens in the contract address for ICO and Dividends
101             name = tokenName;                                   // Set the name for display purposes
102             symbol = tokenSymbol;                               // Set the symbol for display purposes
103         }
104     
105         /**
106          * Internal transfer, only can be called by this contract
107          */
108         function _transfer(address _from, address _to, uint _value) internal {
109             // Prevent transfer to 0x0 address. Use burn() instead
110             require(_to != 0x0);
111             // Check if the sender has enough
112             require(balanceOf[_from] >= _value);
113             // Check for overflows
114             require(balanceOf[_to].add(_value) > balanceOf[_to]);
115             // Save this for an assertion in the future
116             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
117             // Subtract from the sender
118             balanceOf[_from] = balanceOf[_from].sub(_value);
119             // Add the same to the recipient
120             balanceOf[_to] = balanceOf[_to].add(_value);
121             emit Transfer(_from, _to, _value);
122             // Asserts are used to use static analysis to find bugs in your code. They should never fail
123             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
124         }
125     
126         /**
127          * Transfer tokens
128          *
129          * Send `_value` tokens to `_to` from your account
130          *
131          * @param _to The address of the recipient
132          * @param _value the amount to send
133          */
134         function transfer(address _to, uint256 _value) public {
135             _transfer(msg.sender, _to, _value);
136         }
137     
138         /**
139          * Transfer tokens from other address
140          *
141          * Send `_value` tokens to `_to` in behalf of `_from`
142          *
143          * @param _from The address of the sender
144          * @param _to The address of the recipient
145          * @param _value the amount to send
146          */
147         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148             require(_value <= allowance[_from][msg.sender]);     // Check allowance
149             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
150             _transfer(_from, _to, _value);
151             return true;
152         }
153     
154         /**
155          * Set allowance for other address
156          *
157          * Allows `_spender` to spend no more than `_value` tokens in your behalf
158          *
159          * @param _spender The address authorized to spend
160          * @param _value the max amount they can spend
161          */
162         function approve(address _spender, uint256 _value) public
163             returns (bool success) {
164             allowance[msg.sender][_spender] = _value;
165             return true;
166         }
167     
168         /**
169          * Set allowance for other address and notify
170          *
171          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
172          *
173          * @param _spender The address authorized to spend
174          * @param _value the max amount they can spend
175          * @param _extraData some extra information to send to the approved contract
176          */
177         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
178             public
179             returns (bool success) {
180             tokenRecipient spender = tokenRecipient(_spender);
181             if (approve(_spender, _value)) {
182                 spender.receiveApproval(msg.sender, _value, this, _extraData);
183                 return true;
184             }
185         }
186     
187         /**
188          * Destroy tokens
189          *
190          * Remove `_value` tokens from the system irreversibly
191          *
192          * @param _value the amount of money to burn
193          */
194         function burn(uint256 _value) public returns (bool success) {
195             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
196             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
197             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
198            emit Burn(msg.sender, _value);
199             return true;
200         }
201     
202         /**
203          * Destroy tokens from other account
204          *
205          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
206          *
207          * @param _from the address of the sender
208          * @param _value the amount of money to burn
209          */
210         function burnFrom(address _from, uint256 _value) public returns (bool success) {
211             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
212             require(_value <= allowance[_from][msg.sender]);    // Check allowance
213             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
214             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
215             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
216           emit  Burn(_from, _value);
217             return true;
218         }
219     }
220     
221     /********************************************************/
222     /*       MAIN GAS FUND TOKEN CONTRACT STARTS HERE       */
223     /********************************************************/
224     
225     contract GasFund is owned, TokenERC20 {
226         using SafeMath for uint256;
227         
228         //**************************************************//
229         //------------- Code for the GAF Token -------------//
230         //**************************************************//
231         
232         // Public variables of the token
233     	string internal tokenName = "Gas Fund";
234         string internal tokenSymbol = "GAF";
235         uint256 internal initialSupply = 50000000000; 	// Initial supply of the tokens   
236 	
237     	// Records for the fronzen accounts 
238         mapping (address => bool) public frozenAccount;
239     
240         // This generates a public event on the blockchain that will notify clients 
241         event FrozenFunds(address target, bool frozen);
242     
243         // Initializes contract with initial supply of tokens sent to the creator as well as contract 
244         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {
245             tokenHolderExist[msg.sender] = true;
246             tokenHolders.push(msg.sender);
247         }
248     
249          
250         /**
251          * Transfer tokens - Internal transfer, only can be called by this contract
252          * 
253          * This checks if the sender or recipient is not fronzen
254          * 
255          * This keeps the track of total token holders and adds new holders as well.
256          *
257          * Send `_value` tokens to `_to` from your account
258          *
259          * @param _from The address of the sender
260          * @param _to The address of the recipient
261          * @param _value the amount of tokens to send
262          */
263         function _transfer(address _from, address _to, uint _value) internal {
264             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
265             require (balanceOf[_from] >= _value);               // Check if the sender has enough
266             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
267             require(!frozenAccount[_from]);                     // Check if sender is frozen
268             require(!frozenAccount[_to]);                       // Check if recipient is frozen
269             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
270             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
271             //if receiver does not exist in tokenHolderExist mapping, then add into it as well as add in tokenHolders array
272             if(!tokenHolderExist[_to]){
273                 tokenHolderExist[_to] = true;
274                 tokenHolders.push(_to);
275             }
276            emit Transfer(_from, _to, _value);
277         }
278     
279         /**
280          * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
281          * 
282          * @param target Address to be frozen
283          * @param freeze either to freeze it or not
284          */
285         function freezeAccount(address target, bool freeze) onlyOwner public {
286             frozenAccount[target] = freeze;
287           emit  FrozenFunds(target, freeze);
288         }
289     
290         //**************************************************//
291         //------------- Code for the Crowdsale -------------//
292         //**************************************************//
293     
294         //public variables for the Crowdsale
295         uint256 public icoStartDate = 1540800000 ;  // October 29, 2018 - 8am GMT
296         uint256 public icoEndDate   = 1548057600 ;  // January 21, 2019 - 8am GMT
297         uint256 public exchangeRate = 1000;         // 1 ETH = 1000 GAF which equals to 1 GAF = 0.001 ETH
298         uint256 public totalTokensForICO = 12000000;// Tokens allocated for crowdsale
299         uint256 public tokensSold = 0;              // How many tokens sold in crowdsale
300         bool internal withdrawTokensOnlyOnce = true;// Admin can withdraw unsold tokens after ICO only once
301         
302         /**
303          * Fallback function, only accepts ether if ICO is running or Reject
304          * 
305          * It calcualtes token amount from exchangeRate and also adds Bonuses if applicable
306          * 
307          * Ether will be forwarded to owner immidiately.
308          */
309 		function () payable public {
310     		require(icoEndDate > now);
311     		require(icoStartDate < now);
312     		uint ethervalueWEI=msg.value;
313     		uint256 token = ethervalueWEI.mul(exchangeRate);    // token amount = weiamount * price
314     		uint256 totalTokens = token.add(purchaseBonus(token)); // token + bonus
315     		tokensSold = tokensSold.add(totalTokens);
316     		_transfer(this, msg.sender, totalTokens);           // makes the token transfer
317     		forwardEherToOwner();                               // send ether to owner
318 		}
319         
320         
321         /**
322          * Automatocally forwards ether from smart contract to owner address.
323          */
324 		function forwardEherToOwner() internal {
325 			owner.transfer(msg.value); 
326 		}
327 		
328 		/**
329          * Calculates purchase bonus according to the schedule.
330          * 
331          * @param _tokenAmount calculating tokens from amount of tokens 
332          * 
333          * @return bonus amount in wei
334          * 
335          */
336 		function purchaseBonus(uint256 _tokenAmount) public view returns(uint256){
337 		    uint256 first24Hours = icoStartDate + 86400;    //Level 1: First 24 hours = 50% bonus
338 		    uint256 week1 = first24Hours + 604800;    //Level 2: next 7 days = 40%
339 		    uint256 week2 = week1 + 604800;           //Level 3: next 7 days = 30%
340 		    uint256 week3 = week2 + 604800;           //Level 4: next 7 days = 25%
341 		    uint256 week4 = week3 + 604800;           //Level 5: next 7 days = 20%
342 		    uint256 week5 = week4 + 604800;           //Level 6: next 7 days = 15%
343 		    uint256 week6 = week5 + 604800;           //Level 7: next 7 days = 10%
344 		    uint256 week7 = week6 + 604800;           //Level 8: next 7 days = 5%
345 
346 		    if(now < (first24Hours)){ 
347                 return _tokenAmount.div(2);             //50% bonus
348 		    }
349 		    else if(now > first24Hours && now < week1){
350 		        return _tokenAmount.mul(40).div(100);   //40% bonus
351 		    }
352 		    else if(now > week1 && now < week2){
353 		        return _tokenAmount.mul(30).div(100);   //30% bonus
354 		    }
355 		    else if(now > week2 && now < week3){
356 		        return _tokenAmount.mul(25).div(100);   //25% bonus
357 		    }
358 		    else if(now > week3 && now < week4){
359 		        return _tokenAmount.mul(20).div(100);   //20% bonus
360 		    }
361 		    else if(now > week4 && now < week5){
362 		        return _tokenAmount.mul(15).div(100);   //15% bonus
363 		    }
364 		    else if(now > week5 && now < week6){
365 		        return _tokenAmount.mul(10).div(100);   //10% bonus
366 		    }
367 		    else if(now > week6 && now < week7){
368 		        return _tokenAmount.mul(5).div(100);   //5% bonus
369 		    }
370 		    else{
371 		        return 0;
372 		    }
373 		}
374         
375         
376         /**
377          * Function to check wheter ICO is running or not. 
378          * 
379          * @return bool for whether ICO is running or not
380          */
381         function isICORunning() public view returns(bool){
382             if(icoEndDate > now && icoStartDate < now){
383                 return true;                
384             }else{
385                 return false;
386             }
387         }
388         
389         
390         /**
391          * Function to withdraw unsold tokens to owner after ICO is over 
392          * 
393          * This can be called only once. 
394          */
395         function withdrawTokens() onlyOwner public {
396             require(icoEndDate < now);
397             require(withdrawTokensOnlyOnce);
398             uint256 tokens = (totalTokensForICO.mul(1 ether)).sub(tokensSold);
399             _transfer(this, msg.sender, tokens);
400             withdrawTokensOnlyOnce = false;
401         }
402         
403         
404         //*********************************************************//
405         //------------- Code for the Divident Payment -------------//
406         //*********************************************************//
407         
408         uint256 public dividendStartDate = 1549008000;  // February 1, 2019 8:00:00 AM - GMT
409         uint256 public dividendMonthCounter = 0;
410         uint256 public monthlyAllocation = 6594333;
411         
412         //Following mapping which track record whether token holder exist or not
413         mapping(address => bool) public tokenHolderExist;
414         
415         //Array of addresses of token holders
416         address[] public tokenHolders;
417         
418         //Following is necessary to split the iteration of array execution to token transfer
419         uint256 public tokenHolderIndex = 0;
420         
421         
422         event DividendPaid(uint256 totalDividendPaidThisRound, uint256 lastAddressIndex);
423 
424         /**
425          * Just to check if dividend payment is available to send out 
426          * 
427          * This function will be called from the clients side to check if main dividend payment function should be called or not.
428          * 
429          * @return length or array of token holders. If 0, means not available. If more than zero, then the time has come for dividend payment
430          */
431         function checkDividendPaymentAvailable() public view returns (uint256){
432             require(now > (dividendStartDate.add(dividendMonthCounter.mul(2592000))));
433             return tokenHolders.length;
434         }
435         
436         /**
437          * Main function to call to distribute the dividend payment
438          * 
439          * It will only work every month once, according to dividend schedule
440          * 
441          * It will send only 150 token transfer at a time, to prevent eating out all the gas if token holders are so many.
442          * 
443          * If there are more than 150 token holders, then this function must be called multiple times
444          * 
445          * And it will resume from where it was left over.
446          * 
447          * Dividend percentage is is calculated and distributed from the monthly token allocation.
448          * 
449          * Monthly allocation multiplies every month by 1.5%
450          */
451         function runDividendPayment() public { 
452             if(now > (dividendStartDate.add(dividendMonthCounter.mul(2592000)))){
453                 uint256 totalDividendPaidThisRound = 0;
454                 //Total token balance hold by all the token holders, is total supply minus - tokens in the contract
455                 uint256 totalTokensHold = totalSupply.sub(balanceOf[this]);
456                 for(uint256 i = 0; i < 150; i++){
457                     if(tokenHolderIndex < tokenHolders.length){
458                         uint256 userTokens = balanceOf[tokenHolders[tokenHolderIndex]];
459                         if(userTokens > 0){
460                             uint256 dividendPercentage =  userTokens.div(totalTokensHold);
461                             uint256 dividend = monthlyAllocation.mul(1 ether).mul(dividendPercentage);
462                             _transfer(this, tokenHolders[tokenHolderIndex], dividend);
463                             tokenHolderIndex++;
464                             totalDividendPaidThisRound = totalDividendPaidThisRound.add(dividend);
465                         }
466                     }else{
467                         //this code will run only once in 30 days when dividendPaymentAvailable is true and all the dividend has been paid
468                         tokenHolderIndex = 0;
469                         dividendMonthCounter++;
470                         monthlyAllocation = monthlyAllocation.add(monthlyAllocation.mul(15).div(1000)); //1.5% multiplication of monthlyAllocation each month
471                         break;
472                     }
473                 }
474                 //final tokenHolderIndex woluld be 0 instead of last index of the array.
475                 emit DividendPaid(totalDividendPaidThisRound,  tokenHolderIndex);
476             }
477         }
478     }