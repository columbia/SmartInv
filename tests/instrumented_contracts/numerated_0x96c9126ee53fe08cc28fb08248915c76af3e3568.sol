1 pragma solidity 0.4.25;
2 /*
3 
4  __      __          ___                                          ______                     
5 /\ \  __/\ \        /\_ \                                        /\__  _\                    
6 \ \ \/\ \ \ \     __\//\ \     ___    ___     ___ ___      __    \/_/\ \/   ___              
7  \ \ \ \ \ \ \  /'__`\\ \ \   /'___\ / __`\ /' __` __`\  /'__`\     \ \ \  / __`\            
8   \ \ \_/ \_\ \/\  __/ \_\ \_/\ \__//\ \L\ \/\ \/\ \/\ \/\  __/      \ \ \/\ \L\ \__  __  __ 
9    \ `\___x___/\ \____\/\____\ \____\ \____/\ \_\ \_\ \_\ \____\      \ \_\ \____/\_\/\_\/\_\
10     '\/__//__/  \/____/\/____/\/____/\/___/  \/_/\/_/\/_/\/____/       \/_/\/___/\/_/\/_/\/_/
11                                                                                              
12                                                                                              
13 
14 __/\\\\\\\\\\\\\\\__/\\\_________________/\\\\\\\\\\\_______/\\\\\\\\\____        
15  _\/\\\///////////__\/\\\_______________/\\\/////////\\\___/\\\\\\\\\\\\\__       
16   _\/\\\_____________\/\\\______________\//\\\______\///___/\\\/////////\\\_      
17    _\/\\\\\\\\\\\_____\/\\\_______________\////\\\_________\/\\\_______\/\\\_     
18     _\/\\\///////______\/\\\__________________\////\\\______\/\\\\\\\\\\\\\\\_    
19      _\/\\\_____________\/\\\_____________________\////\\\___\/\\\/////////\\\_   
20       _\/\\\_____________\/\\\______________/\\\______\//\\\__\/\\\_______\/\\\_  
21        _\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_\///\\\\\\\\\\\/___\/\\\_______\/\\\_ 
22         _\///////////////__\///////////////____\///////////_____\///________\///__
23 
24 
25 
26 // ----------------------------------------------------------------------------
27 // 'Elisia' contract with following features
28 //      => In-built ICO functionality
29 //      => ERC20 Compliance
30 //      => Higher control of ICO by owner
31 //      => selfdestruct functionality
32 //      => SafeMath implementation 
33 //      => Air-drop
34 //      => User whitelisting
35 //      => Minting new tokens by owner
36 //
37 // Deployed to : 0x94eE9BdC075ff971207D888a9151970169279C82
38 // Symbol      : ELSA
39 // Name        : Elisia
40 // Total supply: 1,000,000,000  (1 Billion)
41 // Reserved coins for ICO: 750,000,000 ELSA (750 Million)
42 // Decimals    : 18
43 //
44 // Copyright (c) 2018 Elisia Inc. (https://Elisia.io)
45 // Contract designed by EtherAuthority (https://EtherAuthority.io)
46 // ----------------------------------------------------------------------------
47   
48 */ 
49 
50 //*******************************************************************//
51 //------------------------ SafeMath Library -------------------------//
52 //*******************************************************************//
53     /**
54      * @title SafeMath
55      * @dev Math operations with safety checks that throw on error
56      */
57     library SafeMath {
58       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60           return 0;
61         }
62         uint256 c = a * b;
63         assert(c / a == b);
64         return c;
65       }
66     
67       function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         // assert(b > 0); // Solidity automatically throws when dividing by 0
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71         return c;
72       }
73     
74       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         assert(b <= a);
76         return a - b;
77       }
78     
79       function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         assert(c >= a);
82         return c;
83       }
84     }
85 
86 
87 //*******************************************************************//
88 //------------------ Contract to Manage Ownership -------------------//
89 //*******************************************************************//
90     
91     contract owned {
92         address public owner;
93         
94          constructor () public {
95             owner = msg.sender;
96         }
97     
98         modifier onlyOwner {
99             require(msg.sender == owner);
100             _;
101         }
102     
103         function transferOwnership(address newOwner) onlyOwner public {
104             owner = newOwner;
105         }
106     }
107     
108     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
109 
110 
111 //***************************************************************//
112 //------------------ ERC20 Standard Template -------------------//
113 //***************************************************************//
114     
115     contract TokenERC20 {
116         // Public variables of the token
117         using SafeMath for uint256;
118         string public name;
119         string public symbol;
120         uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
121         uint256 public totalSupply;
122         uint256 public reservedForICO;
123         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
124     
125         // This creates an array with all balances
126         mapping (address => uint256) public balanceOf;
127         mapping (address => mapping (address => uint256)) public allowance;
128     
129         // This generates a public event on the blockchain that will notify clients
130         event Transfer(address indexed from, address indexed to, uint256 value);
131     
132         // This notifies clients about the amount burnt
133         event Burn(address indexed from, uint256 value);
134     
135         /**
136          * Constrctor function
137          *
138          * Initializes contract with initial supply tokens to the creator of the contract
139          */
140         constructor (
141             uint256 initialSupply,
142             uint256 allocatedForICO,
143             string tokenName,
144             string tokenSymbol
145         ) public {
146             totalSupply = initialSupply.mul(1 ether);       // Update total supply with the decimal amount
147             reservedForICO = allocatedForICO.mul(1 ether);  // Tokens reserved For ICO
148             balanceOf[this] = reservedForICO;           // 2.5 Billion ELC will remain in the contract
149             balanceOf[msg.sender]=totalSupply.sub(reservedForICO); // Rest of tokens will be sent to owner
150             name = tokenName;                           // Set the name for display purposes
151             symbol = tokenSymbol;                       // Set the symbol for display purposes
152         }
153     
154         /**
155          * Internal transfer, only can be called by this contract
156          */
157         function _transfer(address _from, address _to, uint _value) internal {
158             require(!safeguard);
159             // Prevent transfer to 0x0 address. Use burn() instead
160             require(_to != 0x0);
161             // Check if the sender has enough
162             require(balanceOf[_from] >= _value);
163             // Check for overflows
164             require(balanceOf[_to].add(_value) > balanceOf[_to]);
165             // Save this for an assertion in the future
166             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
167             // Subtract from the sender
168             balanceOf[_from] = balanceOf[_from].sub(_value);
169             // Add the same to the recipient
170             balanceOf[_to] = balanceOf[_to].add(_value);
171             emit Transfer(_from, _to, _value);
172             // Asserts are used to use static analysis to find bugs in your code. They should never fail
173             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
174         }
175     
176         /**
177          * Transfer tokens
178          *
179          * Send `_value` tokens to `_to` from your account
180          *
181          * @param _to The address of the recipient
182          * @param _value the amount to send
183          */
184         function transfer(address _to, uint256 _value) public returns (bool success) {
185             _transfer(msg.sender, _to, _value);
186             return true;
187         }
188     
189         /**
190          * Transfer tokens from other address
191          *
192          * Send `_value` tokens to `_to` in behalf of `_from`
193          *
194          * @param _from The address of the sender
195          * @param _to The address of the recipient
196          * @param _value the amount to send
197          */
198         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
199             require(!safeguard);
200             require(_value <= allowance[_from][msg.sender]);     // Check allowance
201             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
202             _transfer(_from, _to, _value);
203             return true;
204         }
205     
206         /**
207          * Set allowance for other address
208          *
209          * Allows `_spender` to spend no more than `_value` tokens in your behalf
210          *
211          * @param _spender The address authorized to spend
212          * @param _value the max amount they can spend
213          */
214         function approve(address _spender, uint256 _value) public
215             returns (bool success) {
216             require(!safeguard);
217             allowance[msg.sender][_spender] = _value;
218             return true;
219         }
220     
221         /**
222          * Set allowance for other address and notify
223          *
224          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
225          *
226          * @param _spender The address authorized to spend
227          * @param _value the max amount they can spend
228          * @param _extraData some extra information to send to the approved contract
229          */
230         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
231             public
232             returns (bool success) {
233             require(!safeguard);
234             tokenRecipient spender = tokenRecipient(_spender);
235             if (approve(_spender, _value)) {
236                 spender.receiveApproval(msg.sender, _value, this, _extraData);
237                 return true;
238             }
239         }
240     
241         /**
242          * Destroy tokens
243          *
244          * Remove `_value` tokens from the system irreversibly
245          *
246          * @param _value the amount of money to burn
247          */
248         function burn(uint256 _value) public returns (bool success) {
249             require(!safeguard);
250             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
251             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
252             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
253             emit Burn(msg.sender, _value);
254             return true;
255         }
256     
257         /**
258          * Destroy tokens from other account
259          *
260          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
261          *
262          * @param _from the address of the sender
263          * @param _value the amount of money to burn
264          */
265         function burnFrom(address _from, uint256 _value) public returns (bool success) {
266             require(!safeguard);
267             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
268             require(_value <= allowance[_from][msg.sender]);    // Check allowance
269             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
270             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
271             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
272             emit  Burn(_from, _value);
273             return true;
274         }
275         
276     }
277     
278 //************************************************************************//
279 //---------------------  ELISIA MAIN CODE STARTS HERE --------------------//
280 //************************************************************************//
281     
282     contract Elisia is owned, TokenERC20 {
283         
284         /*************************************/
285         /*  User whitelisting functionality  */
286         /*************************************/
287         bool public whitelistingStatus = false;
288         mapping (address => bool) public whitelisted;
289         
290         /**
291          * Change whitelisting status on or off
292          *
293          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
294          */
295         function changeWhitelistingStatus() onlyOwner public{
296             if (whitelistingStatus == false){
297                 whitelistingStatus = true;
298             }
299             else{
300                 whitelistingStatus = false;    
301             }
302         }
303         
304         /**
305          * Whitelist any user address - only Owner can do this
306          *
307          * It will add user address in whitelisted mapping
308          */
309         function whitelistUser(address userAddress) onlyOwner public{
310             require(whitelistingStatus == true);
311             require(userAddress != 0x0);
312             whitelisted[userAddress] = true;
313         }
314         
315         /**
316          * Whitelist Many user address at once - only Owner can do this
317          * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack
318          * It will add user address in whitelisted mapping
319          */
320         function whitelistManyUsers(address[] userAddresses) onlyOwner public{
321             require(whitelistingStatus == true);
322             uint256 addressCount = userAddresses.length;
323             require(addressCount <= 150);
324             for(uint256 i = 0; i < addressCount; i++){
325                 require(userAddresses[i] != 0x0);
326                 whitelisted[userAddresses[i]] = true;
327             }
328         }
329         
330         
331         
332         /*********************************/
333         /* Code for the ERC20 ELSA Token */
334         /*********************************/
335     
336         /* Public variables of the token */
337         string private tokenName = "Elisia";
338         string private tokenSymbol = "ELSA";
339         uint256 private initialSupply = 1000000000;     // 1 Billion
340         uint256 private allocatedForICO = 750000000;    // 750 Million
341         
342         
343         /* Records for the fronzen accounts */
344         mapping (address => bool) public frozenAccount;
345         
346         /* This generates a public event on the blockchain that will notify clients */
347         event FrozenFunds(address target, bool frozen);
348     
349         /* Initializes contract with initial supply tokens to the creator of the contract */
350         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}
351 
352         /* Internal transfer, only can be called by this contract */
353         function _transfer(address _from, address _to, uint _value) internal {
354             require(!safeguard);
355             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
356             require (balanceOf[_from] >= _value);               // Check if the sender has enough
357             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
358             require(!frozenAccount[_from]);                     // Check if sender is frozen
359             require(!frozenAccount[_to]);                       // Check if recipient is frozen
360             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
361             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
362             emit Transfer(_from, _to, _value);
363         }
364         
365         /// @notice Create `mintedAmount` tokens and send it to `target`
366         /// @param target Address to receive the tokens
367         /// @param mintedAmount the amount of tokens it will receive
368         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
369             balanceOf[target] = balanceOf[target].add(mintedAmount);
370             totalSupply = totalSupply.add(mintedAmount);
371             emit Transfer(0, this, mintedAmount);
372             emit Transfer(this, target, mintedAmount);
373         }
374 
375         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
376         /// @param target Address to be frozen
377         /// @param freeze either to freeze it or not
378         function freezeAccount(address target, bool freeze) onlyOwner public {
379                 frozenAccount[target] = freeze;
380             emit  FrozenFunds(target, freeze);
381         }
382 
383         /*******************************/
384         /* Code for the ELSA Crowdsale */
385         /*******************************/
386         
387         /* TECHNICAL SPECIFICATIONS:
388         
389         => ICO starts           :  November 30th 6.00 GMT
390         => ICO Ends             :  January 25th 23.59 GMT
391         => Token Exchange Rate  :  1 ETH = 10,000 ELSA (which equals to 1 ELSA = 0.0001 ETH)
392         => Bonus Rounds:
393             First 24 hours: 45%
394             Day 2 - Day 7: 35%
395             Day 8 - Day 14: 30%
396             Day 15 - Day 21: 25%
397             Day 22 - Day 28: 20%
398             Day 29 - Day 35: 15%
399             Day 36 - Day 42: 10%
400             Day 43 - Day 49: 5%
401             Day 50 - Day 56: NO BONUS
402         => Coins reserved for ICO : 750,000,000
403         => Contribution Limits  : No minimum or maximum Contribution 
404 
405         */
406 
407         //public variables for the Crowdsale
408         uint256 public icoStartDate = 154355760 ;      // 30 November 2018 06:00:00 - GMT
409         uint256 public icoEndDate   = 1548460740 ;      // 25 January 2019 23:59:00 - GMT
410         uint256 public exchangeRate = 10000;            // 1 ETH = 10000 Tokens 
411         uint256 public tokensSold = 0;                  // how many tokens sold through crowdsale
412         
413         //@dev fallback function, only accepts ether if pre-sale or ICO is running or Reject
414         function () payable external {
415             require(!safeguard);
416             require(!frozenAccount[msg.sender]);
417             if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }
418             require(icoStartDate < now && icoEndDate > now);
419             // calculate token amount to be sent
420             uint256 token = msg.value.mul(exchangeRate);                        //weiamount * exchangeRate
421             uint256 finalTokens = token.add(calculatePurchaseBonus(token));     //add bonus if available
422             tokensSold = tokensSold.add(finalTokens);
423             _transfer(this, msg.sender, finalTokens);                           //makes the transfers
424             forwardEherToOwner();                                               //send Ether to owner
425         }
426 
427         
428         //calculating purchase bonus
429         //SafeMath library is not used here at some places intentionally, as overflow is impossible here
430         //And thus it saves gas cost if we avoid using SafeMath in such cases
431         function calculatePurchaseBonus(uint256 token) internal view returns(uint256){
432             if(icoStartDate < now && (icoStartDate + 86400) > now ){
433                 return token.mul(45).div(100);  //45% bonus in first 24 hours
434             }
435             else if((icoStartDate + 86400) < now && (icoStartDate + (86400*7)) > now){
436                 return token.mul(35).div(100);  //Day 2 - Day 7: 35%
437             }
438             else if((icoStartDate + (86400*7)) < now && (icoStartDate + (86400*14)) > now){
439                 return token.mul(30).div(100);  //Day 8 - Day 14: 30%
440             }
441             else if((icoStartDate + (86400*14)) < now && (icoStartDate + (86400*21)) > now){
442                 return token.mul(25).div(100);  //Day 15 - Day 21: 25%
443             }
444             else if((icoStartDate + (86400*21)) < now && (icoStartDate + (86400*28)) > now){
445                 return token.mul(20).div(100);  //Day 22 - Day 28: 20%
446             }
447             else if((icoStartDate + (86400*28)) < now && (icoStartDate + (86400*35)) > now){
448                 return token.mul(15).div(100);  //Day 29 - Day 35: 15%
449             }
450             else if((icoStartDate + (86400*35)) < now && (icoStartDate + (86400*42)) > now){
451                 return token.mul(10).div(100);  //Day 36 - Day 42: 10%
452             }
453             else if((icoStartDate + (86400*42)) < now && (icoStartDate + (86400*49)) > now){
454                 return token.mul(5).div(100);  //Day 43 - Day 49: 5%
455             }
456             else{
457                 return 0;                       // Day 50 - Day 56: NO BONUS
458             }
459         }
460 
461         //Automatocally forwards ether from smart contract to owner address
462         function forwardEherToOwner() internal {
463             address(owner).transfer(msg.value); 
464         }
465 
466         //Function to update an ICO parameter.
467         //It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens)
468         //Owner need to make sure the contract has enough tokens for ICO. 
469         //If not enough, then he needs to transfer some tokens into contract addresss from his wallet
470         //If there are no tokens in smart contract address, then ICO will not work.
471         function updateCrowdsale(uint256 icoStartDateNew, uint256 icoEndDateNew, uint256 exchangeRateNew) onlyOwner public {
472             require(icoStartDateNew < icoEndDateNew);
473             icoStartDate = icoStartDateNew;
474             icoEndDate = icoEndDateNew;
475             exchangeRate = exchangeRateNew;
476         }
477         
478         //Stops an ICO.
479         //It will just set the ICO end date to zero and thus it will stop an ICO
480         function stopICO() onlyOwner public{
481             icoEndDate = 0;
482         }
483         
484         //function to check wheter ICO is running or not. 
485         //It will return current state of the crowdsale
486         function icoStatus() public view returns(string){
487             if(icoStartDate < now && icoEndDate > now ){
488                 return "ICO is running";
489             }else if(icoStartDate > now){
490                 return "ICO will start on November 30th 6.00 GMT";
491             }else{
492                 return "ICO is over";
493             }
494         }
495         
496         //Function to set ICO Exchange rate. 
497         //1 ETH = How many Tokens ?
498         function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
499             exchangeRate=newExchangeRate;
500         }
501         
502         //Just in case, owner wants to transfer Tokens from contract to owner address
503         function manualWithdrawToken(uint256 _amount) onlyOwner public {
504             uint256 tokenAmount = _amount.mul(1 ether);
505             _transfer(this, msg.sender, tokenAmount);
506         }
507           
508         //Just in case, owner wants to transfer Ether from contract to owner address
509         function manualWithdrawEther()onlyOwner public{
510             uint256 amount=address(this).balance;
511             address(owner).transfer(amount);
512         }
513         
514         //selfdestruct function. just in case owner decided to destruct this contract.
515         function destructContract()onlyOwner public{
516             selfdestruct(owner);
517         }
518         
519         /**
520          * Change safeguard status on or off
521          *
522          * When safeguard is true, then all the non-owner functions will stop working.
523          * When safeguard is false, then all the functions will resume working back again!
524          */
525         function changeSafeguardStatus() onlyOwner public{
526             if (safeguard == false){
527                 safeguard = true;
528             }
529             else{
530                 safeguard = false;    
531             }
532         }
533         
534         
535         /*********************************/
536         /* Code for the Air drop of ELSA */
537         /*********************************/
538         
539         /**
540          * Run an Air-Drop
541          *
542          * It requires an array of all the addresses and amount of tokens to distribute
543          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
544          */
545         function airdrop(address[] recipients,uint tokenAmount) public onlyOwner {
546             uint256 addressCount = recipients.length;
547             require(addressCount <= 150);
548             for(uint i = 0; i < addressCount; i++)
549             {
550                   //This will loop through all the recipients and send them the specified tokens
551                   _transfer(this, recipients[i], tokenAmount.mul(1 ether));
552             }
553         }
554 }