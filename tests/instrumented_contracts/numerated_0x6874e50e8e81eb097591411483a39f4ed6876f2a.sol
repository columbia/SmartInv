1 pragma solidity 0.4.25; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12 ##    ## ######## ##      ##    ########  ######## ##     ## 
13 ##   ##  ##       ##  ##  ##    ##     ## ##        ##   ##  
14 ##  ##   ##       ##  ##  ##    ##     ## ##         ## ##   
15 #####    ######   ##  ##  ##    ##     ## ######      ###    
16 ##  ##   ##       ##  ##  ##    ##     ## ##         ## ##   
17 ##   ##  ##       ##  ##  ##    ##     ## ##        ##   ##  
18 ##    ## ########  ###  ###     ########  ######## ##     ## 
19 
20 
21 
22 // ----------------------------------------------------------------------------
23 // 'KewDex' Token contract with following functionalities:
24 //      => In-built ICO functionality
25 //      => ERC20 Compliance
26 //      => Higher control of ICO by owner
27 //      => selfdestruct functionality
28 //      => SafeMath implementation 
29 //      => Air-drop
30 //      => User whitelisting
31 //      => Minting/Burning tokens by owner
32 //
33 // Name             : KewDex
34 // Symbol           : KEW
35 // Total supply     : 75,000,000,000 (75 Billion)
36 // Reserved for ICO : 60,000,000,000  (60 Billion)
37 // Decimals         : 8
38 //
39 // Copyright (c) 2018 KewDex Inc. ( https://KewDex.com ) The MIT Licence.
40 // Contract designed by: EtherAuthority ( https://EtherAuthority.io ) 
41 // ----------------------------------------------------------------------------
42 */ 
43 
44 
45 //*******************************************************************//
46 //------------------------ SafeMath Library -------------------------//
47 //*******************************************************************//
48     /**
49      * @title SafeMath
50      * @dev Math operations with safety checks that throw on error
51      */
52     library SafeMath {
53       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55           return 0;
56         }
57         uint256 c = a * b;
58         assert(c / a == b);
59         return c;
60       }
61     
62       function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return c;
67       }
68     
69       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72       }
73     
74       function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78       }
79     }
80 
81 
82 //*******************************************************************//
83 //------------------ Contract to Manage Ownership -------------------//
84 //*******************************************************************//
85     
86     contract owned {
87         address public owner;
88         
89          constructor () public {
90             owner = msg.sender;
91         }
92     
93         modifier onlyOwner {
94             require(msg.sender == owner);
95             _;
96         }
97     
98         function transferOwnership(address newOwner) onlyOwner public {
99             owner = newOwner;
100         }
101     }
102     
103     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
104 
105 
106 //***************************************************************//
107 //------------------ ERC20 Standard Template -------------------//
108 //***************************************************************//
109     
110     contract TokenERC20 {
111         // Public variables of the token
112         using SafeMath for uint256;
113         string public name;
114         string public symbol;
115         uint256 public decimals = 8; 
116         uint256 public totalSupply;
117         uint256 public reservedForICO;
118         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
119     
120         // This creates an array with all balances
121         mapping (address => uint256) public balanceOf;
122         mapping (address => mapping (address => uint256)) public allowance;
123     
124         // This generates a public event on the blockchain that will notify clients
125         event Transfer(address indexed from, address indexed to, uint256 value);
126     
127         // This notifies clients about the amount burnt
128         event Burn(address indexed from, uint256 value);
129     
130         /**
131          * Constrctor function
132          *
133          * Initializes contract with initial supply tokens to the creator of the contract
134          */
135         constructor (
136             uint256 initialSupply,
137             uint256 allocatedForICO,
138             string tokenName,
139             string tokenSymbol
140         ) public {
141             totalSupply = initialSupply * (1e8);       // Update total supply with the decimal amount
142             reservedForICO = allocatedForICO * (1e8);   // Tokens reserved For ICO
143             balanceOf[this] = reservedForICO;               // 60 Billion Tokens will remain in the contract
144             balanceOf[msg.sender] = totalSupply - reservedForICO; // Rest of tokens will be sent to owner
145             name = tokenName;                               // Set the name for display purposes
146             symbol = tokenSymbol;                           // Set the symbol for display purposes
147         }
148     
149         /**
150          * Internal transfer, only can be called by this contract
151          */
152         function _transfer(address _from, address _to, uint _value) internal {
153             require(!safeguard);
154             // Prevent transfer to 0x0 address. Use burn() instead
155             require(_to != 0x0);
156             // Check if the sender has enough
157             require(balanceOf[_from] >= _value);
158             // Check for overflows
159             require(balanceOf[_to].add(_value) > balanceOf[_to]);
160             // Save this for an assertion in the future
161             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
162             // Subtract from the sender
163             balanceOf[_from] = balanceOf[_from].sub(_value);
164             // Add the same to the recipient
165             balanceOf[_to] = balanceOf[_to].add(_value);
166             emit Transfer(_from, _to, _value);
167             // Asserts are used to use static analysis to find bugs in your code. They should never fail
168             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
169         }
170     
171         /**
172          * Transfer tokens
173          *
174          * Send `_value` tokens to `_to` from your account
175          *
176          * @param _to The address of the recipient
177          * @param _value the amount to send
178          */
179         function transfer(address _to, uint256 _value) public returns (bool success) {
180             _transfer(msg.sender, _to, _value);
181             return true;
182         }
183     
184         /**
185          * Transfer tokens from other address
186          *
187          * Send `_value` tokens to `_to` in behalf of `_from`
188          *
189          * @param _from The address of the sender
190          * @param _to The address of the recipient
191          * @param _value the amount to send
192          */
193         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
194             require(!safeguard);
195             require(_value <= allowance[_from][msg.sender]);     // Check allowance
196             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
197             _transfer(_from, _to, _value);
198             return true;
199         }
200     
201         /**
202          * Set allowance for other address
203          *
204          * Allows `_spender` to spend no more than `_value` tokens in your behalf
205          *
206          * @param _spender The address authorized to spend
207          * @param _value the max amount they can spend
208          */
209         function approve(address _spender, uint256 _value) public
210             returns (bool success) {
211             require(!safeguard);
212             allowance[msg.sender][_spender] = _value;
213             return true;
214         }
215     
216         /**
217          * Set allowance for other address and notify
218          *
219          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
220          *
221          * @param _spender The address authorized to spend
222          * @param _value the max amount they can spend
223          * @param _extraData some extra information to send to the approved contract
224          */
225         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
226             public
227             returns (bool success) {
228             require(!safeguard);
229             tokenRecipient spender = tokenRecipient(_spender);
230             if (approve(_spender, _value)) {
231                 spender.receiveApproval(msg.sender, _value, this, _extraData);
232                 return true;
233             }
234         }
235     
236         /**
237          * Destroy tokens
238          *
239          * Remove `_value` tokens from the system irreversibly
240          *
241          * @param _value the amount of money to burn
242          */
243         function burn(uint256 _value) public returns (bool success) {
244             require(!safeguard);
245             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
246             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
247             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
248             emit Burn(msg.sender, _value);
249             return true;
250         }
251     
252         /**
253          * Destroy tokens from other account
254          *
255          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
256          *
257          * @param _from the address of the sender
258          * @param _value the amount of money to burn
259          */
260         function burnFrom(address _from, uint256 _value) public returns (bool success) {
261             require(!safeguard);
262             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
263             require(_value <= allowance[_from][msg.sender]);    // Check allowance
264             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
265             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
266             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
267             emit  Burn(_from, _value);
268             return true;
269         }
270         
271     }
272     
273 //************************************************************************//
274 //---------------------  KEWDEX MAIN CODE STARTS HERE --------------------//
275 //************************************************************************//
276     
277     contract KewDex is owned, TokenERC20 {
278         
279         /*************************************/
280         /*  User whitelisting functionality  */
281         /*************************************/
282         bool public whitelistingStatus = false;
283         mapping (address => bool) public whitelisted;
284         
285         /**
286          * Change whitelisting status on or off
287          *
288          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
289          */
290         function changeWhitelistingStatus() onlyOwner public{
291             if (whitelistingStatus == false){
292                 whitelistingStatus = true;
293             }
294             else{
295                 whitelistingStatus = false;    
296             }
297         }
298         
299         /**
300          * Whitelist any user address - only Owner can do this
301          *
302          * It will add user address in whitelisted mapping
303          */
304         function whitelistUser(address userAddress) onlyOwner public{
305             require(whitelistingStatus == true);
306             require(userAddress != 0x0);
307             whitelisted[userAddress] = true;
308         }
309         
310         /**
311          * Whitelist Many user address at once - only Owner can do this
312          * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack
313          * It will add user address in whitelisted mapping
314          */
315         function whitelistManyUsers(address[] userAddresses) onlyOwner public{
316             require(whitelistingStatus == true);
317             uint256 addressCount = userAddresses.length;
318             require(addressCount <= 150);
319             for(uint256 i = 0; i < addressCount; i++){
320                 require(userAddresses[i] != 0x0);
321                 whitelisted[userAddresses[i]] = true;
322             }
323         }
324         
325         
326         
327         /********************************/
328         /* Code for the ERC20 KEW Token */
329         /********************************/
330     
331         /* Public variables of the token */
332         string private tokenName = "KewDex";
333         string private tokenSymbol = "KEW";
334         uint256 private initialSupply = 75000000000;     // 75 Billion
335         uint256 private allocatedForICO = 60000000000;   // 60 Billion
336         
337         
338         /* Records for the fronzen accounts */
339         mapping (address => bool) public frozenAccount;
340         
341         /* This generates a public event on the blockchain that will notify clients */
342         event FrozenFunds(address target, bool frozen);
343     
344         /* Initializes contract with initial supply tokens to the creator of the contract */
345         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}
346 
347         /* Internal transfer, only can be called by this contract */
348         function _transfer(address _from, address _to, uint _value) internal {
349             require(!safeguard);
350             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
351             require (balanceOf[_from] >= _value);               // Check if the sender has enough
352             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
353             require(!frozenAccount[_from]);                     // Check if sender is frozen
354             require(!frozenAccount[_to]);                       // Check if recipient is frozen
355             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
356             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
357             emit Transfer(_from, _to, _value);
358         }
359         
360         /// @notice Create `mintedAmount` tokens and send it to `target`
361         /// @param target Address to receive the tokens
362         /// @param mintedAmount the amount of tokens it will receive
363         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
364             balanceOf[target] = balanceOf[target].add(mintedAmount);
365             totalSupply = totalSupply.add(mintedAmount);
366             emit Transfer(0, this, mintedAmount);
367             emit Transfer(this, target, mintedAmount);
368         }
369 
370         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
371         /// @param target Address to be frozen
372         /// @param freeze either to freeze it or not
373         function freezeAccount(address target, bool freeze) onlyOwner public {
374                 frozenAccount[target] = freeze;
375             emit  FrozenFunds(target, freeze);
376         }
377 
378         /******************************/
379         /* Code for the KEW Crowdsale */
380         /******************************/
381         
382         /* TECHNICAL SPECIFICATIONS:
383         
384         => ICO starts           :  Will be specified by owner
385         => ICO Ends             :  Will be specified by owner
386         => Token Exchange Rate  :  1 ETH = 45,000,000 Tokens 
387         => Bonus                :  66%   
388         => Coins reserved for ICO : 60,000,000,000  (60 Billion)
389         => Contribution Limits  : No minimum or maximum Contribution 
390         => Ether Withdrawal     : Ether can only be transfered after ICO is over
391 
392         */
393 
394         //public variables for the Crowdsale
395         uint256 public icoStartDate = 123 ;         // ICO start timestamp will be updated by owner after contract deployment
396         uint256 public icoEndDate   = 999999999999; // ICO end timestamp will be updated by owner after contract deployment
397         uint256 public exchangeRate = 45000000;     // 1 ETH = 45 Million Tokens 
398         uint256 public tokensSold = 0;              // How many tokens sold through crowdsale
399         uint256 public purchaseBonus = 66;          // Purchase Bonus purcentage - 66%
400         
401         //@dev fallback function, only accepts ether if pre-sale or ICO is running or Reject
402         function () payable external {
403             require(!safeguard);
404             require(!frozenAccount[msg.sender]);
405             if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }
406             require(icoStartDate < now && icoEndDate > now);
407             // calculate token amount to be sent
408             uint256 token = msg.value.mul(exchangeRate).div(1e10);              //weiamount * exchangeRate
409             uint256 finalTokens = token.add(calculatePurchaseBonus(token));     //add bonus if available
410             tokensSold = tokensSold.add(finalTokens);
411             _transfer(this, msg.sender, finalTokens);                           //makes the transfers
412             
413         }
414 
415         
416         //calculating purchase bonus
417         //SafeMath library is not used here at some places intentionally, as overflow is impossible here
418         //And thus it saves gas cost if we avoid using SafeMath in such cases
419         function calculatePurchaseBonus(uint256 token) internal view returns(uint256){
420             if(purchaseBonus > 0){
421                 return token.mul(purchaseBonus).div(100);  //66% bonus
422             }
423             else{
424                 return 0;
425             }
426         }
427         
428 
429         //Function to update an ICO parameter.
430         //It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens)
431         //Owner need to make sure the contract has enough tokens for ICO. 
432         //If not enough, then he needs to transfer some tokens into contract addresss from his wallet
433         //If there are no tokens in smart contract address, then ICO will not work.
434         function updateCrowdsale(uint256 icoStartDateNew, uint256 icoEndDateNew, uint256 exchangeRateNew) onlyOwner public {
435             require(icoStartDateNew < icoEndDateNew);
436             icoStartDate = icoStartDateNew;
437             icoEndDate = icoEndDateNew;
438             exchangeRate = exchangeRateNew;
439         }
440         
441         //Stops an ICO.
442         //It will just set the ICO end date to zero and thus it will stop an ICO
443         function stopICO() onlyOwner public{
444             icoEndDate = 0;
445         }
446         
447         //function to check wheter ICO is running or not. 
448         //It will return current state of the crowdsale
449         function icoStatus() public view returns(string){
450             if(icoStartDate < now && icoEndDate > now ){
451                 return "ICO is running";
452             }else if(icoStartDate > now){
453                 return "ICO has not started yet";
454             }else{
455                 return "ICO is over";
456             }
457         }
458         
459         //Function to set ICO Exchange rate. 
460         //1 ETH = How many Tokens ?
461         function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
462             exchangeRate=newExchangeRate;
463         }
464         
465         //Function to update ICO Purchase Bonus. 
466         //Enter percentage of the bonus. eg, 66 for 66% bonus
467         function updatePurchaseBonus(uint256 newPurchaseBonus) onlyOwner public {
468             purchaseBonus=newPurchaseBonus;
469         }
470         
471         //Just in case, owner wants to transfer Tokens from contract to owner address
472         function manualWithdrawToken(uint256 _amount) onlyOwner public {
473             uint256 tokenAmount = _amount * (1e8);
474             _transfer(this, msg.sender, tokenAmount);
475         }
476           
477         //When owner wants to transfer Ether from contract to owner address
478         //ICO must be over in order to do the ether transfer
479         //Entire Ether balance will be transfered to owner address
480         function manualWithdrawEther() onlyOwner public{
481             require(icoEndDate < now, 'ICO is not over!');
482             address(owner).transfer(address(this).balance);
483         }
484         
485         //selfdestruct function. just in case owner decided to destruct this contract.
486         function destructContract() onlyOwner public{
487             selfdestruct(owner);
488         }
489         
490         /**
491          * Change safeguard status on or off
492          *
493          * When safeguard is true, then all the non-owner functions will stop working.
494          * When safeguard is false, then all the functions will resume working back again!
495          */
496         function changeSafeguardStatus() onlyOwner public{
497             if (safeguard == false){
498                 safeguard = true;
499             }
500             else{
501                 safeguard = false;    
502             }
503         }
504         
505         
506         /********************************/
507         /* Code for the Air drop of KEW */
508         /********************************/
509         
510         /**
511          * Run an Air-Drop
512          *
513          * It requires an array of all the addresses and amount of tokens to distribute
514          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
515          */
516         function airdrop(address[] recipients,uint tokenAmount) public onlyOwner {
517             uint256 addressCount = recipients.length;
518             require(addressCount <= 150);
519             for(uint i = 0; i < addressCount; i++)
520             {
521                   //This will loop through all the recipients and send them the specified tokens
522                   _transfer(this, recipients[i], tokenAmount * (1e8));
523             }
524         }
525 }