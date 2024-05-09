1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35  mapping (address => uint) public pendingWithdrawals;
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 
65 
66 function withdraw() {
67         uint amount = pendingWithdrawals[msg.sender];
68         pendingWithdrawals[msg.sender] = 0;
69         msg.sender.transfer(amount);
70     }
71 
72 }
73 /**
74  * @title Claimable
75  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
76  * This allows the new owner to accept the transfer.
77  */
78 
79 contract AirDrop is Ownable {
80 
81   Token token;
82 
83   event TransferredToken(address indexed to, uint256 value);
84   event FailedTransfer(address indexed to, uint256 value);
85 
86   modifier whenDropIsActive() {
87     assert(isActive());
88 
89     _;
90   }
91 address public creator;
92   function AirDrop () {
93       address _tokenAddr = creator; //here pass address of your token
94       token = Token(_tokenAddr);
95   }
96 
97   function isActive() constant returns (bool) {
98     return (
99         tokensAvailable() > 0 // Tokens must be available to send
100     );
101   }
102   //below function can be used when you want to send every recipeint with different number of tokens
103   function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
104     uint256 i = 0;
105     while (i < dests.length) {
106         uint256 toSend = values[i] ;
107         sendInternally(dests[i] , toSend, values[i]);
108         i++;
109     }
110   }
111 
112   // this function can be used when you want to send same number of tokens to all the recipients
113   function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
114     uint256 i = 0;
115     uint256 toSend = value;
116     while (i < dests.length) {
117         sendInternally(dests[i] , toSend, value);
118         i++;
119     }
120   }  
121 
122   function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
123     if(recipient == address(0)) return;
124 
125     if(tokensAvailable() >= tokensToSend) {
126       token.transfer(recipient, tokensToSend);
127       TransferredToken(recipient, valueToPresent);
128     } else {
129       FailedTransfer(recipient, valueToPresent); 
130     }
131   }   
132 
133 
134   function tokensAvailable() constant returns (uint256) {
135     return token.balanceOf(this);
136   }
137 
138 }
139 contract Claimable is Ownable {
140     address public pendingOwner;
141 
142     /**
143      * @dev Modifier throws if called by any account other than the pendingOwner.
144      */
145     modifier onlyPendingOwner() {
146         require(msg.sender == pendingOwner);
147         _;
148     }
149 
150     /**
151      * @dev Allows the current owner to set the pendingOwner address.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function transferOwnership(address newOwner) onlyOwner public {
155         pendingOwner = newOwner;
156     }
157 
158     /**
159      * @dev Allows the pendingOwner address to finalize the transfer.
160      */
161     function claimOwnership() onlyPendingOwner public {
162         OwnershipTransferred(owner, pendingOwner);
163         owner = pendingOwner;
164         pendingOwner = address(0);
165     }
166 
167 
168 }
169 
170 
171 contract EtherToFARM is Ownable {
172  using SafeMath for uint;
173  using SafeMath for uint256;
174 
175 
176 uint256 public totalSupply;// total no of tokens in supply
177 uint remaining;
178 uint price;
179 
180 mapping (address => uint) investors; //it maps no of FarmCoin given to each address
181 
182  function div(uint256 a, uint256 b) internal constant returns (uint256) {
183     // assert(b > 0); // Solidity automatically throws when dividing by 0
184     uint256 c = a / b;
185     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186     return c;
187   }
188 
189 function sub(uint256 a, uint256 b) internal constant returns (uint256) {
190     assert(b <= a);
191     return a - b;
192   }
193 
194  function add(uint256 a, uint256 b) internal constant returns (uint256) {
195     uint256 c = a + b;
196     assert(c >= a);
197     return c;
198   }
199 
200 function transfer(address _to, uint256 _value) returns (bool success) {}
201 
202 function ()  payable {// called when ether is send
203 
204     uint256 remaining;
205     uint256 totalSupply;
206     uint price;
207     assert(remaining < totalSupply);
208     uint FarmCoin = div(msg.value,price); // calculate no of FarmCoin to be issued depending on the price and ether send
209     assert(FarmCoin < sub(totalSupply,remaining)); //FarmCoin available should be greater than the one to be issued
210     add(investors[msg.sender],FarmCoin);
211     remaining = add(remaining, FarmCoin);
212     transfer(msg.sender, FarmCoin);
213 }
214 
215 function setPrice(uint _price)
216 { //  price need to be set maually as it cannot be done via ethereum network
217     uint price;
218     price = _price;
219 }
220 }
221 
222 contract PayToken is EtherToFARM {
223  function() public payable{
224          if(msg.sender!=owner)
225        giveReward(msg.sender,msg.value);
226 }
227 
228  function giveReward(address _payer,uint _payment) public payable returns (bool _success){
229         uint tokenamount = _payment / price;
230         return transfer(_payer,tokenamount);
231     }     
232 }
233 
234 contract Token is EtherToFARM, PayToken {
235 
236     /// @param _owner The address from which the balance will be retrieved
237     /// @return The balance
238     function balanceOf(address _owner) constant returns (uint256 balance) {}
239 
240     /// @notice send `_value` token to `_to` from `msg.sender`
241     /// @param _to The address of the recipient
242     /// @param _value The amount of token to be transferred
243     /// @return Whether the transfer was successful or not
244     function transfer(address _to, uint256 _value) returns (bool success) {}
245 
246     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
247     /// @param _from The address of the sender
248     /// @param _to The address of the recipient
249     /// @param _value The amount of token to be transferred
250     /// @return Whether the transfer was successful or not
251     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
252 
253     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
254     /// @param _spender The address of the account able to transfer the tokens
255     /// @param _value The amount of wei to be approved for transfer
256     /// @return Whether the approval was successful or not
257     function approve(address _spender, uint256 _value) returns (bool success) {}
258 
259     /// @param _owner The address of the account owning tokens
260     /// @param _spender The address of the account able to transfer the tokens
261     /// @return Amount of remaining tokens allowed to spent
262     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
263 
264     event Transfer(address indexed _from, address indexed _to, uint256 _value);
265     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
266     
267 }
268 
269 
270 contract StandardToken is Token {
271 
272     function transfer(address _to, uint256 _value) returns (bool success) {
273         //Default assumes totalSupply can't be over max (2^256 - 1).
274         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
275         //Replace the if with this one instead.
276         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
277         if (balances[msg.sender] >= _value && _value > 0) {
278             balances[msg.sender] -= _value;
279             balances[_to] += _value;
280             Transfer(msg.sender, _to, _value);
281             return true;
282         } else { return false; }
283     }
284 
285    
286 uint constant MAX_UINT = 2**256 - 1;
287 
288 /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
289 /// @param _from Address to transfer from.
290 /// @param _to Address to transfer to.
291 /// @param _value Amount to transfer.
292 /// @return Success of transfer.
293 function transferFrom(address _from, address _to, uint _value)
294     public
295     returns (bool)
296 {
297     uint allowance = allowed[_from][msg.sender];
298     require(balances[_from] >= _value
299             && allowance >= _value
300             && balances[_to] + _value >= balances[_to]);
301     balances[_to] += _value;
302     balances[_from] -= _value;
303     if (allowance < MAX_UINT) {
304         allowed[_from][msg.sender] -= _value;
305     }
306     Transfer(_from, _to, _value);
307     return true;
308 }
309 
310     function balanceOf(address _owner) constant returns (uint256 balance) {
311         return balances[_owner];
312     }
313 
314     function approve(address _spender, uint256 _value) returns (bool success) {
315         allowed[msg.sender][_spender] = _value;
316         Approval(msg.sender, _spender, _value);
317         return true;
318     }
319 
320     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
321       return allowed[_owner][_spender];
322     }
323 
324     mapping (address => uint256) balances;
325     mapping (address => mapping (address => uint256)) allowed;
326     uint256 public totalSupply;
327 }
328 
329 
330 
331 //name this contract whatever you'd like
332 contract FarmCoin is StandardToken {
333 
334    
335     /* Public variables of the token */
336 
337     /*
338     NOTE:
339     The following variables are OPTIONAL vanities. One does not have to include them.
340     They allow one to customise the token contract & in no way influences the core functionality.
341     Some wallets/interfaces might not even bother to look at this information.
342     */
343     string public name = 'WorldFarmCoin';                   //fancy name: eg Simon Bucks
344     uint8 public decimals = 0;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
345     string public symbol = 'WFARM';                 //An identifier: eg SBX
346     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
347 
348 //
349 // CHANGE THESE VALUES FOR YOUR TOKEN
350 //
351 
352 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
353 
354     function FarmCoin(
355         ) {
356         balances[msg.sender] = 5000000;               // Give the creator all initial tokens (100000 for example)
357         totalSupply = 5000000;                        // Update total supply (100000 for example)
358         name = "WorldFarmCoin";                                   // Set the name for display purposes
359         decimals = 0;                            // Amount of decimals for display purposes
360         symbol = "WFARM";                               // Set the symbol for display purposes
361     }
362 
363     /* Approves and then calls the receiving contract */
364     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
365         allowed[msg.sender][_spender] = _value;
366         Approval(msg.sender, _spender, _value);
367 
368         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
369         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
370         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
371         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert; }
372         return true;
373     }
374 }
375 
376 
377 contract FarmCoinSale is FarmCoin {
378  using SafeMath for uint256;
379     uint256 public maxMintable;
380     uint256 public totalMinted;
381     uint256 totalTokens;
382     uint256 public decimals = 0;
383     uint public endBlock;
384     uint public startBlock;
385     uint256 public exchangeRate;
386     
387     uint public startTime;
388     bool public isFunding;
389     address public ETHWallet;
390     uint256 public heldTotal;
391 
392     bool private configSet;
393     address public creator;
394 
395     mapping (address => uint256) public heldTokens;
396     mapping (address => uint) public heldTimeline;
397 
398     event Contribution(address from, uint256 amount);
399     event ReleaseTokens(address from, uint256 amount);
400 
401 // start and end dates where crowdsale is allowed (both inclusive)
402   uint256 constant public START = 1517461200000; // +new Date(2018, 2, 1) / 1000
403   uint256 constant public END = 1522555200000; // +new Date(2018, 4, 1) / 1000
404 
405 // @return the rate in FARM per 1 ETH according to the time of the tx and the FARM pricing program.
406     // @Override
407   function getRate() constant returns (uint256 rate) {
408     if      (now < START)            return rate = 1190476190476200; // presale, 40% bonus
409     else if (now <= START +  6 days) return rate = 1234567900000000 ; // day 1 to 6, 35% bonus
410     else if (now <= START + 13 days) return rate = 1282051300000000 ; // day 7 to 13, 30% bonus
411     else if (now <= START + 20 days) return rate = 1333333300000000 ; // day 14 to 20, 25% bonus
412     else if (now <= START + 28 days) return rate = 1388888900000000 ; // day 21 to 28, 20% bonus
413     return rate = 1666666700000000; // no bonus
414  
415   }
416   
417 
418  mapping (address => uint256) balance;
419  mapping (address => mapping (address => uint256)) allowed;
420 
421  
422     function buy() payable returns (bool success) {
423 	if (!isFunding) {return true;} 
424 	else {
425 	var buyPrice = getRate();
426 	buyPrice;
427 	uint amount = msg.value / buyPrice;                
428         totalTokens += amount;                          
429         balance[msg.sender] += amount;                   
430         Transfer(this, msg.sender, amount); 
431 	return true; }            
432     }
433 
434     function fund (uint256 amount) onlyOwner {
435         if (!msg.sender.send(amount)) {                      		
436           revert;                                         
437         }           
438     }
439 
440     function () payable {
441     var buyPrice = getRate();
442 	buyPrice;
443 	uint amount = msg.value / buyPrice;                
444         totalTokens += amount;                          
445         balance[msg.sender] += amount;                   
446         Transfer(this, msg.sender, amount); 
447 	 }               
448     
449     function FarmCoinSale() {
450         startBlock = block.number;
451         maxMintable = 5000000; // 3 million max sellable (18 decimals)
452         ETHWallet = 0x3b444fC8c2C45DCa5e6610E49dC54423c5Dcd86E;
453         isFunding = true;
454         
455         creator = msg.sender;
456         createHeldCoins();
457         startTime = 1517461200000;
458         var buyPrice = getRate();
459 	    buyPrice;
460         }
461 
462  
463     // setup function to be ran only 1 time
464     // setup token address
465     // setup end Block number
466     function setup(address TOKEN, uint endBlockTime) {
467         require(!configSet);
468         endBlock = endBlockTime;
469         configSet = true;
470     }
471 
472     function closeSale() external {
473       require(msg.sender==creator);
474       isFunding = false;
475     }
476 
477     // CONTRIBUTE FUNCTION
478     // converts ETH to TOKEN and sends new TOKEN to the sender
479     function contribute() external payable {
480         require(msg.value>0);
481         require(isFunding);
482         require(block.number <= endBlock);
483         uint256 amount = msg.value * exchangeRate;
484         uint256 total = totalMinted + amount;
485         require(total<=maxMintable);
486         totalMinted += total;
487         ETHWallet.transfer(msg.value);
488         Contribution(msg.sender, amount);
489     }
490 
491     function deposit() payable {
492       create(msg.sender);
493     }
494     function register(address sender) payable {
495     }
496   
497     function create(address _beneficiary) payable{
498     uint256 amount = msg.value;
499     /// 
500     }
501 
502     function withdraw() {
503     require ( msg.sender == owner );
504     msg.sender.transfer(this.balance);
505 }
506     // update the ETH/COIN rate
507     function updateRate(uint256 rate) external {
508         require(msg.sender==creator);
509         require(isFunding);
510         exchangeRate = rate;
511     }
512 
513     // change creator address
514     function changeCreator(address _creator) external {
515         require(msg.sender==creator);
516         creator = _creator;
517     }
518 
519     // change transfer status for WorldFarmCoin token
520     function changeTransferStats(bool _allowed) external {
521         require(msg.sender==creator);
522      }
523 
524     // internal function that allocates a specific amount of ATYX at a specific block number.
525     // only ran 1 time on initialization
526     function createHeldCoins() internal {
527         // TOTAL SUPPLY = 5,000,000
528         createHoldToken(msg.sender, 0);
529         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 1000000);
530         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 1000000);
531     }
532 
533     // function to create held tokens for developer
534     function createHoldToken(address _to, uint256 amount) internal {
535         heldTokens[_to] = amount;
536         heldTimeline[_to] = block.number + 0;
537         heldTotal += amount;
538         totalMinted += heldTotal;
539     }
540 
541     // function to release held tokens for developers
542     function releaseHeldCoins() external {
543         uint256 held = heldTokens[msg.sender];
544         uint heldBlock = heldTimeline[msg.sender];
545         require(!isFunding);
546         require(held >= 0);
547         require(block.number >= heldBlock);
548         heldTokens[msg.sender] = 0;
549         heldTimeline[msg.sender] = 0;
550         ReleaseTokens(msg.sender, held);
551     }
552 
553 }