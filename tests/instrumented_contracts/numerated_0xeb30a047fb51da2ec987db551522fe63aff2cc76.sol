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
138   function destroy() onlyOwner {
139     uint256 balance = tokensAvailable();
140     require (balance > 0);
141     token.transfer(owner, balance);
142     selfdestruct(owner);
143   }
144 }
145 contract Claimable is Ownable {
146     address public pendingOwner;
147 
148     /**
149      * @dev Modifier throws if called by any account other than the pendingOwner.
150      */
151     modifier onlyPendingOwner() {
152         require(msg.sender == pendingOwner);
153         _;
154     }
155 
156     /**
157      * @dev Allows the current owner to set the pendingOwner address.
158      * @param newOwner The address to transfer ownership to.
159      */
160     function transferOwnership(address newOwner) onlyOwner public {
161         pendingOwner = newOwner;
162     }
163 
164     /**
165      * @dev Allows the pendingOwner address to finalize the transfer.
166      */
167     function claimOwnership() onlyPendingOwner public {
168         OwnershipTransferred(owner, pendingOwner);
169         owner = pendingOwner;
170         pendingOwner = address(0);
171     }
172 
173 
174 }
175 
176 
177 contract EtherToFARM is Ownable {
178  using SafeMath for uint;
179  using SafeMath for uint256;
180 
181 
182 uint256 public totalSupply;// total no of tokens in supply
183 uint remaining;
184 uint price;
185 
186 mapping (address => uint) investors; //it maps no of FarmCoin given to each address
187 
188  function div(uint256 a, uint256 b) internal constant returns (uint256) {
189     // assert(b > 0); // Solidity automatically throws when dividing by 0
190     uint256 c = a / b;
191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192     return c;
193   }
194 
195 function sub(uint256 a, uint256 b) internal constant returns (uint256) {
196     assert(b <= a);
197     return a - b;
198   }
199 
200  function add(uint256 a, uint256 b) internal constant returns (uint256) {
201     uint256 c = a + b;
202     assert(c >= a);
203     return c;
204   }
205 
206 function transfer(address _to, uint256 _value) returns (bool success) {}
207 
208 function ()  payable {// called when ether is send
209 
210     uint256 remaining;
211     uint256 totalSupply;
212     uint price;
213     assert(remaining < totalSupply);
214     uint FarmCoin = div(msg.value,price); // calculate no of FarmCoin to be issued depending on the price and ether send
215     assert(FarmCoin < sub(totalSupply,remaining)); //FarmCoin available should be greater than the one to be issued
216     add(investors[msg.sender],FarmCoin);
217     remaining = add(remaining, FarmCoin);
218     transfer(msg.sender, FarmCoin);
219 }
220 
221 function setPrice(uint _price)
222 { //  price need to be set maually as it cannot be done via ethereum network
223     uint price;
224     price = _price;
225 }
226 
227 function giveReward(address _payer,uint _payment) public payable returns (bool _success){
228         uint tokenamount = _payment / price;
229         return transfer(_payer,tokenamount);
230     }    
231 }
232 
233 contract PayToken is EtherToFARM {
234  function() public payable{
235          if(msg.sender!=owner)
236        giveReward(msg.sender,msg.value);
237 }
238 }
239 
240 contract Token is EtherToFARM {
241 
242     /// @param _owner The address from which the balance will be retrieved
243     /// @return The balance
244     function balanceOf(address _owner) constant returns (uint256 balance) {}
245 
246     /// @notice send `_value` token to `_to` from `msg.sender`
247     /// @param _to The address of the recipient
248     /// @param _value The amount of token to be transferred
249     /// @return Whether the transfer was successful or not
250     function transfer(address _to, uint256 _value) returns (bool success) {}
251 
252     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
253     /// @param _from The address of the sender
254     /// @param _to The address of the recipient
255     /// @param _value The amount of token to be transferred
256     /// @return Whether the transfer was successful or not
257     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
258 
259     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
260     /// @param _spender The address of the account able to transfer the tokens
261     /// @param _value The amount of wei to be approved for transfer
262     /// @return Whether the approval was successful or not
263     function approve(address _spender, uint256 _value) returns (bool success) {}
264 
265     /// @param _owner The address of the account owning tokens
266     /// @param _spender The address of the account able to transfer the tokens
267     /// @return Amount of remaining tokens allowed to spent
268     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
269 
270     event Transfer(address indexed _from, address indexed _to, uint256 _value);
271     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
272     
273 }
274 
275 
276 
277 contract StandardToken is Token {
278 
279     function transfer(address _to, uint256 _value) returns (bool success) {
280         //Default assumes totalSupply can't be over max (2^256 - 1).
281         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
282         //Replace the if with this one instead.
283         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
284         if (balances[msg.sender] >= _value && _value > 0) {
285             balances[msg.sender] -= _value;
286             balances[_to] += _value;
287             Transfer(msg.sender, _to, _value);
288             return true;
289         } else { return false; }
290     }
291 
292    
293 uint constant MAX_UINT = 2**256 - 1;
294 
295 /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
296 /// @param _from Address to transfer from.
297 /// @param _to Address to transfer to.
298 /// @param _value Amount to transfer.
299 /// @return Success of transfer.
300 function transferFrom(address _from, address _to, uint _value)
301     public
302     returns (bool)
303 {
304     uint allowance = allowed[_from][msg.sender];
305     require(balances[_from] >= _value
306             && allowance >= _value
307             && balances[_to] + _value >= balances[_to]);
308     balances[_to] += _value;
309     balances[_from] -= _value;
310     if (allowance < MAX_UINT) {
311         allowed[_from][msg.sender] -= _value;
312     }
313     Transfer(_from, _to, _value);
314     return true;
315 }
316 
317     function balanceOf(address _owner) constant returns (uint256 balance) {
318         return balances[_owner];
319     }
320 
321     function approve(address _spender, uint256 _value) returns (bool success) {
322         allowed[msg.sender][_spender] = _value;
323         Approval(msg.sender, _spender, _value);
324         return true;
325     }
326 
327     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
328       return allowed[_owner][_spender];
329     }
330 
331     mapping (address => uint256) balances;
332     mapping (address => mapping (address => uint256)) allowed;
333     uint256 public totalSupply;
334 }
335 
336 
337 
338 //name this contract whatever you'd like
339 contract FarmCoin is StandardToken {
340 
341    
342     /* Public variables of the token */
343 
344     /*
345     NOTE:
346     The following variables are OPTIONAL vanities. One does not have to include them.
347     They allow one to customise the token contract & in no way influences the core functionality.
348     Some wallets/interfaces might not even bother to look at this information.
349     */
350     string public name = 'FarmCoin';                   //fancy name: eg Simon Bucks
351     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
352     string public symbol = 'FARM';                 //An identifier: eg SBX
353     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
354 
355 //
356 // CHANGE THESE VALUES FOR YOUR TOKEN
357 //
358 
359 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
360 
361     function FarmCoin(
362         ) {
363         balances[msg.sender] = 5000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
364         totalSupply = 5000000000000000000000000;                        // Update total supply (100000 for example)
365         name = "FarmCoin";                                   // Set the name for display purposes
366         decimals = 18;                            // Amount of decimals for display purposes
367         symbol = "FARM";                               // Set the symbol for display purposes
368     }
369 
370     /* Approves and then calls the receiving contract */
371     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
372         allowed[msg.sender][_spender] = _value;
373         Approval(msg.sender, _spender, _value);
374 
375         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
376         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
377         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
378         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert; }
379         return true;
380     }
381 }
382 
383 
384 contract FarmCoinSale is FarmCoin {
385 
386     uint256 public maxMintable;
387     uint256 public totalMinted;
388     uint256 public decimals = 18;
389     uint public endBlock;
390     uint public startBlock;
391     uint256 public exchangeRate;
392     uint public startTime;
393     bool public isFunding;
394     address public ETHWallet;
395     uint256 public heldTotal;
396 
397     bool private configSet;
398     address public creator;
399 
400     mapping (address => uint256) public heldTokens;
401     mapping (address => uint) public heldTimeline;
402 
403     event Contribution(address from, uint256 amount);
404     event ReleaseTokens(address from, uint256 amount);
405 
406 // start and end dates where crowdsale is allowed (both inclusive)
407   uint256 constant public START = 1517461200000; // +new Date(2018, 2, 1) / 1000
408   uint256 constant public END = 1522555200000; // +new Date(2018, 4, 1) / 1000
409 
410 // @return the rate in FARM per 1 ETH according to the time of the tx and the FARM pricing program.
411     // @Override
412   function getRate() constant returns (uint256 rate) {
413     if      (now < START)            return rate = 840; // presale, 40% bonus
414     else if (now <= START +  6 days) return rate = 810; // day 1 to 6, 35% bonus
415     else if (now <= START + 13 days) return rate = 780; // day 7 to 13, 30% bonus
416     else if (now <= START + 20 days) return rate = 750; // day 14 to 20, 25% bonus
417     else if (now <= START + 28 days) return rate = 720; // day 21 to 28, 20% bonus
418     return rate = 600; // no bonus
419   }
420 
421 
422     function FarmCoinSale() {
423         startBlock = block.number;
424         maxMintable = 5000000000000000000000000; // 3 million max sellable (18 decimals)
425         ETHWallet = 0x3b444fC8c2C45DCa5e6610E49dC54423c5Dcd86E;
426         isFunding = true;
427         
428         creator = msg.sender;
429         createHeldCoins();
430         startTime = 1517461200000;
431         exchangeRate= 600;
432         }
433 
434  
435     // setup function to be ran only 1 time
436     // setup token address
437     // setup end Block number
438     function setup(address TOKEN, uint endBlockTime) {
439         require(!configSet);
440         endBlock = endBlockTime;
441         configSet = true;
442     }
443 
444     function closeSale() external {
445       require(msg.sender==creator);
446       isFunding = false;
447     }
448 
449     // CONTRIBUTE FUNCTION
450     // converts ETH to TOKEN and sends new TOKEN to the sender
451     function contribute() external payable {
452         require(msg.value>0);
453         require(isFunding);
454         require(block.number <= endBlock);
455         uint256 amount = msg.value * exchangeRate;
456         uint256 total = totalMinted + amount;
457         require(total<=maxMintable);
458         totalMinted += total;
459         ETHWallet.transfer(msg.value);
460         Contribution(msg.sender, amount);
461     }
462 
463     function deposit() payable {
464       create(msg.sender);
465     }
466     function register(address sender) payable {
467     }
468     function () payable {
469     }
470   
471     function create(address _beneficiary) payable{
472     uint256 amount = msg.value;
473     /// 
474     }
475 
476     function withdraw() {
477     require ( msg.sender == owner );
478     msg.sender.transfer(this.balance);
479 }
480     // update the ETH/COIN rate
481     function updateRate(uint256 rate) external {
482         require(msg.sender==creator);
483         require(isFunding);
484         exchangeRate = rate;
485     }
486 
487     // change creator address
488     function changeCreator(address _creator) external {
489         require(msg.sender==creator);
490         creator = _creator;
491     }
492 
493     // change transfer status for FarmCoin token
494     function changeTransferStats(bool _allowed) external {
495         require(msg.sender==creator);
496      }
497 
498     // internal function that allocates a specific amount of ATYX at a specific block number.
499     // only ran 1 time on initialization
500     function createHeldCoins() internal {
501         // TOTAL SUPPLY = 5,000,000
502         createHoldToken(msg.sender, 1000);
503         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
504         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
505     }
506 
507     // function to create held tokens for developer
508     function createHoldToken(address _to, uint256 amount) internal {
509         heldTokens[_to] = amount;
510         heldTimeline[_to] = block.number + 0;
511         heldTotal += amount;
512         totalMinted += heldTotal;
513     }
514 
515     // function to release held tokens for developers
516     function releaseHeldCoins() external {
517         uint256 held = heldTokens[msg.sender];
518         uint heldBlock = heldTimeline[msg.sender];
519         require(!isFunding);
520         require(held >= 0);
521         require(block.number >= heldBlock);
522         heldTokens[msg.sender] = 0;
523         heldTimeline[msg.sender] = 0;
524         ReleaseTokens(msg.sender, held);
525     }
526 
527 }